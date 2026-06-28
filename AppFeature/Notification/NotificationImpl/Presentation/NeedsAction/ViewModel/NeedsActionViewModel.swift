//
//  NeedsActionViewModel.swift
//  NotificationImpl
//
//  Created by Huseyn Hasanov on 28.06.26.
//

import AppUIKit
import AppNetwork
import AppFoundation

final class NeedsActionViewModel: UIFeatureViewModel<NeedsActionFeature> {

    struct Dependencies {
        let useCase: NeedsActionUseCase
    }

    private let router: NeedsActionRouterProtocol
    private let dependencies: NeedsActionViewModel.Dependencies

    private let pageSize = 20

    // Independent page cursors per source.
    private var clubPage = 0
    private var hangoutPage = 0

    init(
        state: NeedsActionFeature.State,
        router: NeedsActionRouterProtocol,
        dependencies: NeedsActionViewModel.Dependencies
    ) {
        self.router = router
        self.dependencies = dependencies
        super.init(initialState: state)
    }

    override func handle(action: NeedsActionFeature.Action) {
        switch action {
        case .onAppear:
            if state.clubs.phase == .idle { loadInitial(.clubs) }
            if state.hangouts.phase == .idle { loadInitial(.hangouts) }
            refreshVerificationBanner()
        case .selectTab(let tab):
            state.selectedTab = tab
        case .refresh(let tab):
            loadInitial(tab)
        case .retry(let tab):
            loadInitial(tab)
        case .loadMore(let tab):
            loadMore(tab)
        case .accept(let item):
            process(item, accept: true)
        case .reject(let item):
            // Defer to the host's confirm alert before touching the API.
            postEffect(.confirmReject(item))
        case .performReject(let item):
            process(item, accept: false)
        case .requestTapped(let item):
            guard let userId = item.requesterId else { return }
            Task { await router.navigate(to: .userProfile(userId: userId)) }
        case .verificationTapped:
            Task { await router.navigate(to: .verification) }
        }
    }

    // MARK: - Verification banner

    /// Probes the admin-only pending endpoint. Success → show banner + count;
    /// any failure (403 / network) → hide it. Doubles as the admin check.
    private func refreshVerificationBanner() {
        Task {
            if let count = try? await dependencies.useCase.fetchVerificationCount() {
                await applyVerification(count: count, isAdmin: true)
            } else {
                await applyVerification(count: 0, isAdmin: false)
            }
        }
    }

    @MainActor
    private func applyVerification(count: Int, isAdmin: Bool) {
        state.verificationCount = count
        state.isAdmin = isAdmin
    }

    // MARK: - Source plumbing

    private func keyPath(for tab: ActionTab) -> ReferenceWritableKeyPath<NeedsActionViewState, RequestSourceState>? {
        switch tab {
        case .clubs:    \.clubs
        case .hangouts: \.hangouts
        case .events:   nil
        }
    }

    private func fetch(_ tab: ActionTab, page: Int) async throws(APIError) -> RequestPageResult? {
        switch tab {
        case .clubs:    try await dependencies.useCase.fetchClubRequests(page: page, size: pageSize)
        case .hangouts: try await dependencies.useCase.fetchHangoutRequests(page: page, size: pageSize)
        case .events:   nil
        }
    }

    private func resetPage(for tab: ActionTab) {
        switch tab {
        case .clubs:    clubPage = 0
        case .hangouts: hangoutPage = 0
        case .events:   break
        }
    }

    private func currentPage(for tab: ActionTab) -> Int {
        switch tab {
        case .clubs:    clubPage
        case .hangouts: hangoutPage
        case .events:   0
        }
    }

    private func setPage(_ page: Int, for tab: ActionTab) {
        switch tab {
        case .clubs:    clubPage = page
        case .hangouts: hangoutPage = page
        case .events:   break
        }
    }

    // MARK: - Loading

    private func loadInitial(_ tab: ActionTab) {
        guard let kp = keyPath(for: tab) else { return }
        resetPage(for: tab)
        if state[keyPath: kp].items.isEmpty {
            state[keyPath: kp].phase = .loading
        }
        Task {
            do {
                guard let result = try await fetch(tab, page: 0) else { return }
                await applyInitial(tab, result: result)
            } catch {
                await applyFailure(tab, error: error as? APIError)
            }
        }
    }

    private func loadMore(_ tab: ActionTab) {
        guard let kp = keyPath(for: tab) else { return }
        let source = state[keyPath: kp]
        guard source.canLoadMore, !source.isLoadingMore else { return }
        state[keyPath: kp].isLoadingMore = true
        let next = currentPage(for: tab) + 1

        Task {
            do {
                guard let result = try await fetch(tab, page: next) else { return }
                await applyMore(tab, page: next, result: result)
            } catch {
                await stopLoadingMore(tab, error: error as? APIError)
            }
        }
    }

    // MARK: - Apply

    @MainActor
    private func applyInitial(_ tab: ActionTab, result: RequestPageResult) {
        guard let kp = keyPath(for: tab) else { return }
        state[keyPath: kp].items = Self.sortedByNewest(result.items)
        state[keyPath: kp].canLoadMore = result.hasMore
        state[keyPath: kp].phase = .loaded
    }

    @MainActor
    private func applyMore(_ tab: ActionTab, page: Int, result: RequestPageResult) {
        guard let kp = keyPath(for: tab) else { return }
        setPage(page, for: tab)
        state[keyPath: kp].items = Self.sortedByNewest(state[keyPath: kp].items + result.items)
        state[keyPath: kp].canLoadMore = result.hasMore
        state[keyPath: kp].isLoadingMore = false
    }

    @MainActor
    private func applyFailure(_ tab: ActionTab, error: APIError?) {
        guard let kp = keyPath(for: tab) else { return }
        if state[keyPath: kp].items.isEmpty {
            state[keyPath: kp].phase = .failed
        }
        postEffect(.error(error))
    }

    @MainActor
    private func stopLoadingMore(_ tab: ActionTab, error: APIError?) {
        guard let kp = keyPath(for: tab) else { return }
        state[keyPath: kp].isLoadingMore = false
        postEffect(.error(error))
    }

    // MARK: - Accept / Reject

    /// Shared accept/reject path — both run a real status API and remove the row
    /// on success, restore + toast on failure.
    private func process(_ item: ActionRequestItem, accept: Bool) {
        guard !state.processingIds.contains(item.id) else { return }
        guard let userId = item.requesterId else {
            postEffect(.error(nil))
            return
        }
        state.processingIds.insert(item.id)

        Task {
            do {
                switch item.kind {
                case .club(let clubId):
                    try await dependencies.useCase.setClubStatus(clubId: clubId, userId: userId, accept: accept)
                case .hangout(let hangoutId):
                    try await dependencies.useCase.setHangoutStatus(hangoutId: hangoutId, userId: userId, accept: accept)
                }
                await finishProcessing(item, removed: true, error: nil)
            } catch {
                await finishProcessing(item, removed: false, error: error as? APIError)
            }
        }
    }

    @MainActor
    private func finishProcessing(_ item: ActionRequestItem, removed: Bool, error: APIError?) {
        state.processingIds.remove(item.id)
        if removed {
            removeItem(item)
        }
        if let error {
            postEffect(.error(error))
        }
    }

    @MainActor
    private func removeItem(_ item: ActionRequestItem) {
        switch item.kind {
        case .club:
            state.clubs.items.removeAll { $0.id == item.id }
        case .hangout:
            state.hangouts.items.removeAll { $0.id == item.id }
        }
    }

    // MARK: - Sort

    /// Newest first; rows missing `createdAt` sink to the bottom but keep order.
    private static func sortedByNewest(_ items: [ActionRequestItem]) -> [ActionRequestItem] {
        items.enumerated().sorted { lhs, rhs in
            switch (lhs.element.createdAt, rhs.element.createdAt) {
            case let (l?, r?) where l != r: return l > r
            case (_?, nil):                 return true
            case (nil, _?):                 return false
            default:                        return lhs.offset < rhs.offset
            }
        }.map(\.element)
    }
}
