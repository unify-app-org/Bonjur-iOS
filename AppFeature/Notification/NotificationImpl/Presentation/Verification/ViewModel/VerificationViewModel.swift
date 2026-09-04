//
//  VerificationViewModel.swift
//  NotificationImpl
//
//  Created by Huseyn Hasanov on 28.06.26.
//

import AppUIKit
import AppNetwork
import AppFoundation

final class VerificationViewModel: UIFeatureViewModel<VerificationFeature> {

    struct Dependencies {
        let useCase: VerificationUseCase
    }

    private let router: VerificationRouterProtocol
    private let dependencies: VerificationViewModel.Dependencies
    private let pageSize = 20
    private var page = 0

    init(
        state: VerificationFeature.State,
        router: VerificationRouterProtocol,
        dependencies: VerificationViewModel.Dependencies
    ) {
        self.router = router
        self.dependencies = dependencies
        super.init(initialState: state)
    }

    override func handle(action: VerificationFeature.Action) {
        switch action {
        case .onAppear:
            if state.phase == .idle { loadInitial() }
        case .refresh, .retry:
            loadInitial()
        case .loadMore:
            loadMore()
        case .verify(let item):
            process(item, accept: true)
        case .performReject(let item, let note):
            process(item, accept: false, rejectionReason: note)
        case .cellTapped(let item):
            Task { await router.navigate(to: .clubDetail(clubId: item.clubId)) }
        }
    }

    // MARK: - Loading

    private func loadInitial() {
        page = 0
        if state.items.isEmpty { state.phase = .loading }
        Task {
            do {
                let result = try await dependencies.useCase.fetchPending(page: 0, size: pageSize)
                await applyInitial(result)
            } catch {
                await applyFailure(error as? APIError)
            }
        }
    }

    private func loadMore() {
        guard state.canLoadMore, !state.isLoadingMore else { return }
        state.isLoadingMore = true
        let next = page + 1
        Task {
            do {
                let result = try await dependencies.useCase.fetchPending(page: next, size: pageSize)
                await applyMore(page: next, result: result)
            } catch {
                await stopLoadingMore(error as? APIError)
            }
        }
    }

    // MARK: - Apply

    @MainActor
    private func applyInitial(_ result: VerificationPageResult) {
        state.items = Self.dedupedById(result.items)
        state.canLoadMore = result.hasMore
        state.phase = .loaded
    }

    @MainActor
    private func applyMore(page: Int, result: VerificationPageResult) {
        self.page = page
        // De-duped before storing: `/clubs/pending` repeats a club across pages and the
        // id is derived from the club id alone, so the same row can arrive twice. On
        // Android the duplicate key takes the screen down; here it silently renders the
        // row twice. Same guard as `NeedsActionViewModel`.
        state.items = Self.dedupedById(state.items + result.items)
        state.canLoadMore = result.hasMore
        state.isLoadingMore = false
    }

    /// Keeps the first occurrence of each id.
    private static func dedupedById(_ items: [VerificationItem]) -> [VerificationItem] {
        var seen = Set<String>()
        return items.filter { seen.insert($0.id).inserted }
    }

    @MainActor
    private func applyFailure(_ error: APIError?) {
        if state.items.isEmpty { state.phase = .failed }
        postEffect(.error(error))
    }

    @MainActor
    private func stopLoadingMore(_ error: APIError?) {
        state.isLoadingMore = false
        postEffect(.error(error))
    }

    // MARK: - Verify / Reject

    private func process(_ item: VerificationItem, accept: Bool, rejectionReason: String? = nil) {
        guard !state.processingIds.contains(item.id) else { return }
        state.processingIds.insert(item.id)
        Task {
            do {
                try await dependencies.useCase.setStatus(
                    clubId: item.clubId,
                    accept: accept,
                    rejectionReason: rejectionReason
                )
                await finishProcessing(item, removed: true, error: nil)
            } catch {
                await finishProcessing(item, removed: false, error: error as? APIError)
            }
        }
    }

    @MainActor
    private func finishProcessing(_ item: VerificationItem, removed: Bool, error: APIError?) {
        state.processingIds.remove(item.id)
        if removed {
            state.items.removeAll { $0.id == item.id }
        }
        if let error {
            postEffect(.error(error))
        }
    }
}
