//
//  EventDetailsViewModel.swift
//  EventsImpl
//
//  Created by Huseyn Hasanov on 01.02.26.
//

import AppFoundation
import AppNetwork
import Communities
import AppUIKit
import AppStorage
import AppPresentationModel

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
        case .userTapped(let id):
            Task { @MainActor in
                router.navigate(to: .userDetail(id))
            }
        case .seeAllMembersTapped:
            presentMembersList()
        case .exitTapped:
            Task { @MainActor in
                presentExitConfirm()
            }
        case .joinTapped:
            Task {
                await joinEvent()
            }
        }
    }

    // MARK: - Join flow

    private func joinEvent() async {
        postEffect(.loading(true))
        defer { postEffect(.loading(false)) }
        do {
            try await dependencies.useCase.joinEvent(eventId: inputData.eventId)
            await showJoinSnackBar()
            fetchData()
        } catch {
            postEffect(.error(error))
        }
    }

    /// Public events join immediately; private events create a pending request.
    @MainActor
    private func showJoinSnackBar() {
        let name = state.uiModel?.name ?? "the event"
        if state.uiModel?.accessType == .private {
            AppSnackBar.show(
                title: "Request sent",
                subtitle: "\(name) will review your request",
                style: .success
            )
        } else {
            AppSnackBar.show(title: "Joined \(name)", style: .success)
        }
    }

    // MARK: - Exit flow

    @MainActor
    private func presentExitConfirm() {
        AppAlertPresenter.present(
            .init(
                config: .init(
                    title: "Leave event?",
                    subtitle: "Are you sure you want to leave this event? You will no longer be able to participate or see updates."
                ),
                actions: {
                    AppAlert.Action(title: "Leave event", style: .destructive) { [weak self] in
                        self?.performExit()
                    }
                    AppAlert.Action(title: "Cancel", style: .primary)
                }
            )
        )
    }

    private func performExit() {
        Task {
            postEffect(.loading(true))
            defer { postEffect(.loading(false)) }
            do {
                try await dependencies.useCase.exitEvent(eventId: inputData.eventId)
                await MainActor.run {
                    AppSnackBar.show(title: "You left the event", style: .success)
                }
                await router.navigate(to: .backTapped)
            } catch {
                await MainActor.run {
                    AppSnackBar.show(
                        title: "Could not leave event",
                        subtitle: "Please try again.",
                        style: .error
                    )
                }
            }
        }
    }

    private func presentMembersList() {
        let eventId = inputData.eventId
        let useCase = dependencies.useCase
        let input = CommunitiesMemberModuleModel.MembersListInput(
            title: "Members",
            titleOverrides: [.president: "Owner"],
            pageSize: 20,
            loadPage: { page, size in
                try await useCase.fetchEventMembersPage(
                    eventId: eventId,
                    page: page,
                    size: size
                )
            },
            onMemberTapped: { [weak self] member in
                Task { @MainActor in
                    self?.router.navigate(to: .userDetail(member.id))
                }
            },
            options: .init(
                viewerRole: .notJoined,
                activity: .events,
                currentUserId: KeychainImpl().getString(key: .userId),
                onAssignRole: { _, _ in false },
                onReport: { _, _ in
                    await MainActor.run { AppSnackBar.show(title: "Report submitted", style: .success) }
                    return true
                }
            )
        )
        Task { @MainActor in
            router.navigate(to: .membersList(input))
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
