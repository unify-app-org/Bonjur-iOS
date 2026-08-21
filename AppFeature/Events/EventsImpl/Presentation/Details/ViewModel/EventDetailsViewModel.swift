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
        let userDefaults: UserDefaultsProtocol
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
        case .remindTapped:
            Task { @MainActor in
                remindTapped()
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

    @MainActor
    private func showJoinSnackBar() {
        let name = state.uiModel?.name ?? "the event"
        if state.uiModel?.accessType == .private {
            AppSnackBar.show(
                title: "events_join_request_sent".localized,
                subtitle: "\(name) will review your request",
                style: .success
            )
        } else {
            AppSnackBar.show(title: "Joined \(name)", style: .success)
        }
    }

    // MARK: - Reminder flow
    @MainActor
    private func remindTapped() {
        guard state.uiModel?.isReminderSent != true else { return }

        guard !dependencies.userDefaults.bool(forKey: .hideEventReminderWarning) else {
            sendReminder()
            return
        }

        var suppressWarning = false
        AppAlertPresenter.present(
            .init(
                config: .init(
                    title: "events_reminder_warning_title".localized,
                    subtitle: "events_reminder_warning_subtitle".localized,
                    checkbox: .init(title: "common_dont_show_again".localized) { isOn in
                        suppressWarning = isOn
                    }
                ),
                actions: {
                    AppAlert.Action(title: "common_cancel".localized, style: .secondary)
                    AppAlert.Action(title: "events_reminder_send".localized, style: .primary) { [weak self] in
                        guard let self else { return }
                        if suppressWarning {
                            self.dependencies.userDefaults.set(true, forKey: .hideEventReminderWarning)
                        }
                        self.sendReminder()
                    }
                }
            )
        )
    }
    
    /// Broadcast the reminder to the group. `POST api/es/v1/events/{id}/reminder`
    /// returns no body, so the spent state is re-read from the detail endpoint
    /// (`isReminder`) instead of assumed locally — the server owns the daily window.
    private func sendReminder() {
        Task {
            postEffect(.loading(true))
            defer { postEffect(.loading(false)) }
            do {
                try await dependencies.useCase.sendReminder(eventId: inputData.eventId)
                await MainActor.run {
                    AppSnackBar.show(
                        title: "events_reminder_sent".localized,
                        subtitle: "events_reminder_sent_sub".localized,
                        style: .success
                    )
                }
                fetchData()
            } catch {
                await MainActor.run {
                    AppSnackBar.show(
                        title: "events_reminder_fail".localized,
                        subtitle: "common_try_again".localized,
                        style: .error
                    )
                }
            }
        }
    }

    // MARK: - Exit flow

    @MainActor
    private func presentExitConfirm() {
        AppAlertPresenter.present(
            .init(
                config: .init(
                    title: "events_leave_title".localized,
                    subtitle: "Are you sure you want to leave this event? You will no longer be able to participate or see updates."
                ),
                actions: {
                    AppAlert.Action(title: "events_leave_confirm".localized, style: .destructive) { [weak self] in
                        self?.performExit()
                    }
                    AppAlert.Action(title: "common_cancel".localized, style: .primary)
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
                    AppSnackBar.show(title: "events_left".localized, style: .success)
                }
                await router.navigate(to: .backTapped)
            } catch {
                await MainActor.run {
                    AppSnackBar.show(
                        title: "events_leave_fail".localized,
                        subtitle: "common_try_again".localized,
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
            title: "Members".localized,
            roleTitles: AppPresentationModel.UserActivityRole
                .localizedTitles(overriding: [.president: "events_owner_role".localized]),
            totalCount: state.uiModel?.membersCount,
            pageSize: 20,
            loadPage: { page, size, keyword in
                try await useCase.fetchEventMembersPage(
                    eventId: eventId,
                    page: page,
                    size: size,
                    keyword: keyword
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
                    await MainActor.run { AppSnackBar.show(title: "events_report_submitted".localized, style: .success) }
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
