//
//  NotificationViewModel.swift
//  NotificationImpl
//
//  Created by Huseyn Hasanov on 27.06.26.
//

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
        case .fetchData:
            fetchData()
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

    private func fetchData() {
        Task {
            do {
                let inbox = try await dependencies.useCase.fetchInbox()
                await apply(inbox)
            } catch {
                postEffect(.error(error as? APIError))
            }
        }
        refreshRequestCount()
    }

    /// Overrides the banner's `requests` count with live totals. Verifications
    /// stay on the mock inbox value until that service ships. Failure leaves the
    /// banner on whatever the inbox provided (silent — it's a secondary number).
    private func refreshRequestCount() {
        Task {
            guard let counts = try? await dependencies.useCase.fetchRequestCounts() else { return }
            await applyRequestCount(counts.total)
        }
    }

    @MainActor
    private func applyRequestCount(_ requests: Int) {
        state.uiModel.action.requests = requests
    }

    private func markAllRead() {
        // Optimistic: clear unread locally, then tell the backend.
        applyAllRead()
        Task {
            do {
                try await dependencies.useCase.markAllRead()
            } catch {
                postEffect(.error(error as? APIError))
            }
        }
    }

    @MainActor
    private func apply(_ inbox: NotificationInbox) {
        state.uiModel = inbox
    }

    private func applyAllRead() {
        for sectionIndex in state.uiModel.sections.indices {
            for itemIndex in state.uiModel.sections[sectionIndex].items.indices {
                state.uiModel.sections[sectionIndex].items[itemIndex].isRead = true
            }
        }
    }
}
