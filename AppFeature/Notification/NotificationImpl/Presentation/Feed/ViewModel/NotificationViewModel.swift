//
//  NotificationViewModel.swift
//  NotificationImpl
//
//  Created by Huseyn Hasanov on 27.06.26.
//

import Foundation
import AppUIKit
import AppNetwork
import AppFoundation

final class NotificationViewModel: UIFeatureViewModel<NotificationFeature> {

    struct Dependencies {
        let useCase: NotificationUseCase
    }

    private let router: NotificationRouterProtocol
    private let inputData: NotificationInputData
    private let dependencies: NotificationViewModel.Dependencies

    private let pageSize = 20
    private var page = 0
    private var feedItems: [NotificationFeedItem] = []

    init(
        state: NotificationFeature.State,
        router: NotificationRouterProtocol,
        inputData: NotificationInputData,
        dependencies: NotificationViewModel.Dependencies
    ) {
        self.router = router
        self.inputData = inputData
        self.dependencies = dependencies
        super.init(initialState: state)
    }

    override func handle(action: NotificationFeature.Action) {
        switch action {
        case .fetchData, .retry:
            fetchData()
        case .loadMore:
            loadMore()
        case .markAllRead:
            markAllRead()
        case .actionBannerTapped:
            Task {
                await router.navigate(to: .needsAction)
            }
        case .itemTapped(let id):
            itemTapped(id: id)
        }
    }

    private func itemTapped(id: String) {
        guard let item = state.uiModel.sections
            .flatMap(\.items)
            .first(where: { $0.id == id }) else { return }

        Task {
            await router.navigate(to: .preview(item))
        }
    }

    // MARK: - Feed loading

    private func fetchData() {
        if state.uiModel.sections.isEmpty {
            state.phase = .loading
        }
        Task {
            do {
                let result = try await dependencies.useCase.fetchFeedPage(page: 0, size: pageSize)
                await applyInitial(result)
            } catch {
                await applyFailure(error as? APIError)
            }
        }
        refreshActionBanner()
    }

    private func loadMore() {
        guard state.canLoadMore, !state.isLoadingMore else { return }
        state.isLoadingMore = true
        let next = page + 1

        Task {
            do {
                let result = try await dependencies.useCase.fetchFeedPage(page: next, size: pageSize)
                await applyMore(result, page: next)
            } catch {
                await stopLoadingMore(error as? APIError)
            }
        }
    }

    @MainActor
    private func applyInitial(_ result: NotificationFeedPage) {
        page = 0
        feedItems = result.items
        state.uiModel.sections = NotificationFeedMapper.sections(from: feedItems)
        state.canLoadMore = result.hasMore
        state.phase = .loaded
    }

    @MainActor
    private func applyMore(_ result: NotificationFeedPage, page nextPage: Int) {
        page = nextPage
        feedItems += result.items
        state.uiModel.sections = NotificationFeedMapper.sections(from: feedItems)
        state.canLoadMore = result.hasMore
        state.isLoadingMore = false
    }

    @MainActor
    private func applyFailure(_ error: APIError?) {
        if state.uiModel.sections.isEmpty {
            state.phase = .failed
        }
        postEffect(.error(error))
    }

    @MainActor
    private func stopLoadingMore(_ error: APIError?) {
        state.isLoadingMore = false
        postEffect(.error(error))
    }

    // MARK: - Needs your action (banner)

    /// Composes the banner client-side: join-request totals (club + hangout +
    /// event) plus the admin-only verification probe (403 → 0, banner shows
    /// requests only). Failures are silent — it's a secondary number.
    private func refreshActionBanner() {
        Task {
            let requests = (try? await dependencies.useCase.fetchRequestCounts())?.total ?? 0
            let verifications = (try? await dependencies.useCase.fetchVerificationCount()) ?? 0
            await applyActionCounts(requests: requests, verifications: verifications)
        }
    }

    @MainActor
    private func applyActionCounts(requests: Int, verifications: Int) {
        state.uiModel.action = .init(requests: requests, verifications: verifications)
    }

    // MARK: - Read state
    /// Explicit toolbar action — flips rows locally too.
    private func markAllRead() {
        applyAllRead()
        Task {
            do {
                try await dependencies.useCase.markAllRead()
            } catch {
                postEffect(.error(error as? APIError))
            }
        }
    }

    private func applyAllRead() {
        for sectionIndex in state.uiModel.sections.indices {
            for itemIndex in state.uiModel.sections[sectionIndex].items.indices {
                state.uiModel.sections[sectionIndex].items[itemIndex].isRead = true
            }
        }
        for index in feedItems.indices {
            feedItems[index].isRead = true
        }
    }
}
