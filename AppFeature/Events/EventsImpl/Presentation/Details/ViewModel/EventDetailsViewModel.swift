//
//  EventDetailsViewModel.swift
//  EventsImpl
//
//  Created by Huseyn Hasanov on 01.02.26.
//

import AppFoundation
import AppNetwork
import Communities

final class EventDetailsViewModel: UIFeatureViewModel<EventDetailsFeature> {

    struct Dependencies {
        let useCase: EventsUseCase
    }

    private struct InitialFetchResults {
        let detail: APIResult<EventsDetailsModel.UIModel>
        let members: APIResult<CommunitiesMemberModuleModel.GroupedMembersData>
    }

    private let router: EventDetailsRouterProtocol
    private let inputData: EventDetailsInputData
    private let dependencies: EventDetailsViewModel.Dependencies

    init(
        state: EventDetailsFeature.State,
        router: EventDetailsRouterProtocol,
        inputData: EventDetailsInputData,
        dependencies: EventDetailsViewModel.Dependencies
    ) {
        self.router = router
        self.inputData = inputData
        self.dependencies = dependencies
        super.init(initialState: state)
    }

    override func handle(action: EventDetailsFeature.Action) {
        switch action {
        case .fetchData:
            fetchData()
        case .backTapped:
            Task {
                await router.navigate(to: .backTapped)
            }
        case .editTapped:
            guard let prefillData = state.uiModel?.editPrefillData else {
                return
            }
            Task {
                await router.navigate(
                    to: .editEvent(
                        id: inputData.eventId,
                        prefillData: prefillData
                    )
                )
            }
        case .clubTapped:
            guard let clubId = state.uiModel?.clubId, clubId != 0 else { return }
            Task {
                await router.navigate(to: .clubDetail(id: clubId))
            }
        }
    }

    private func fetchData() {
        Task {
            postEffect(.loading(true))
            defer {
                postEffect(.loading(false))
            }

            let results = await fetchInitialData()
            let firstError = applyInitialFetchResults(results)

            if let firstError {
                postEffect(.error(firstError))
            }
        }
    }

    private func fetchInitialData() async -> InitialFetchResults {
        async let detail = apiResult {
            try await dependencies.useCase.fetchEventDetail(
                eventId: inputData.eventId
            )
        }
        async let members = apiResult {
            try await dependencies.useCase.fetchEventMembers(
                eventId: inputData.eventId
            )
        }

        return await .init(
            detail: detail,
            members: members
        )
    }

    private func applyInitialFetchResults(
        _ results: InitialFetchResults
    ) -> APIError? {
        var firstError: APIError?

        switch results.detail {
        case .success(let detail):
            Task { @MainActor in
                handleUIModel(detail)
            }
        case .failure(let error):
            firstError = firstError ?? error
        }

        switch results.members {
        case .success(let members):
            Task { @MainActor in
                handleMembers(members)
            }
        case .failure(let error):
            firstError = firstError ?? error
        }
        return firstError
    }

    @MainActor
    private func handleUIModel(_ data: EventsDetailsModel.UIModel) {
        var data = data
        if let existing = state.uiModel?.membersData {
            data.membersData = existing
        }
        state.uiModel = data
    }

    @MainActor
    private func handleMembers(
        _ data: CommunitiesMemberModuleModel.GroupedMembersData
    ) {
        state.members = data
        state.uiModel?.membersData = data
    }
}
