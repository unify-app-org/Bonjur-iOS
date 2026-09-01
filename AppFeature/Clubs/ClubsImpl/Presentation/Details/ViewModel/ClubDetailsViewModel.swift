//
//  ClubDetailsViewModel.swift
//  AppAuth
//
//  Created by Huseyn Hasanov on 29.01.26.
//

import AppFoundation
import Communities
import AppNetwork
import AppUIKit
import AppStorage
import AppPresentationModel
import Events

final class ClubDetailsViewModel: UIFeatureViewModel<ClubDetailsFeature> {
    
    struct Dependencies {
        let useCase: ClubsUseCase
        let eventsModule: EventsModule
    }
    private struct InitialFetchResults {
        let detail: APIResult<ClubsDetailsModel.UIModel>
        let members: APIResult<CommunitiesMemberModuleModel.GroupedMembersData>
        let events: APIResult<[EventsModuleModel.CardInputData]>
    }
    
    private let router: ClubDetailsRouterProtocol
    private let inputData: ClubDetailsInputData
    private let dependencies: ClubDetailsViewModel.Dependencies
    
    init(
        state: ClubDetailsFeature.State,
        router: ClubDetailsRouterProtocol,
        inputData: ClubDetailsInputData,
        dependencies: ClubDetailsViewModel.Dependencies
    ) {
        self.router = router
        self.inputData = inputData
        self.dependencies = dependencies
        super.init(initialState: state)
    }
    
    override func handle(action: ClubDetailsFeature.Action) {
        switch action {
        case .fetchData:
            fetchData()
        case .backTapped:
            Task { @MainActor in
                router.navigate(to: .backTapped)
            }
        case .editTapped:
            guard let prefillData = state.uiModel?.editPrefillData else {
                return
            }
            Task { @MainActor in
                router.navigate(
                    to: .editClub(
                        id: inputData.clubId,
                        prefillData: prefillData
                    )
                )
            }
        case .userTapped(let id):
            Task { @MainActor in
                router.navigate(to: .userDetail(id))
            }
        case .eventTapped(let id):
            Task { @MainActor in
                router.navigate(to: .eventDetail(id))
            }
        case .joinClubTapped:
            Task {
                await joinClub()
            }
        case .seeAllMembersTapped:
            presentMembersList()
        case .assignRole(let userId, let role):
            Task {
                await assignRole(userId: userId, role: role)
            }
        case .exitTapped:
            Task { @MainActor in
                presentExitConfirm()
            }
        case .requestVerificationTapped:
            Task {
                await requestVerification()
            }
        case .createEventTapped:
            Task { @MainActor in
                router.navigate(to: .createEvent(clubId: inputData.clubId))
            }
        }
    }

    // MARK: - Verification

    /// Ask the community admin to verify this club, then refresh so the status
    /// (and the verify CTA) reflects the pending request.
    private func requestVerification() async {
        do {
            try await dependencies.useCase.requestVerify(id: inputData.clubId)
            await MainActor.run {
                AppSnackBar.show(
                    title: "clubs_verification_requested".localized,
                    subtitle: "clubs_verification_requested_sub".localized,
                    style: .success
                )
            }
            fetchData()
        } catch {
            await MainActor.run {
                AppSnackBar.show(
                    title: "clubs_verification_fail".localized,
                    subtitle: "common_try_again".localized,
                    style: .error
                )
            }
        }
    }

    // MARK: - Exit flow

    @MainActor
    private func presentExitConfirm() {
        AppAlertPresenter.present(
            .init(
                config: .init(
                    title: "clubs_exit_title".localized,
                    subtitle: "clubs_exit_subtitle".localized
                ),
                actions: {
                    AppAlert.Action(title: "clubs_exit_confirm".localized, style: .destructive) { [weak self] in
                        self?.handleExitConfirmed()
                    }
                    AppAlert.Action(title: "common_cancel".localized, style: .primary)
                }
            )
        )
    }

    private func handleExitConfirmed() {
        let role = state.uiModel?.userActivityType ?? .notJoined
        Task {
            postEffect(.loading(true))
            // President must hand off ownership: gate exit on an existing VP.
            if role == .president {
                do {
                    let hasVicePresident = try await dependencies.useCase
                        .clubHasVicePresident(id: inputData.clubId)
                    if !hasVicePresident {
                        postEffect(.loading(false))
                        await MainActor.run { self.presentTransferOwnership() }
                        return
                    }
                } catch {
                    postEffect(.loading(false))
                    await showExitError()
                    return
                }
            }
            await performExit()
        }
    }

    private func performExit() async {
        defer { postEffect(.loading(false)) }
        do {
            try await dependencies.useCase.exitClub(id: inputData.clubId)
            await MainActor.run {
                AppSnackBar.show(title: "clubs_left".localized, style: .success)
                router.navigate(to: .backTapped)
            }
        } catch {
            await showExitError()
        }
    }

    @MainActor
    private func presentTransferOwnership() {
        AppAlertPresenter.present(
            .init(
                config: .init(
                    title: "clubs_transfer_title".localized,
                    subtitle: "clubs_transfer_subtitle".localized
                ),
                actions: {
                    AppAlert.Action(title: "common_cancel".localized, style: .secondary)
                    AppAlert.Action(title: "common_assign".localized, style: .primary) { [weak self] in
                        self?.presentMembersList()
                    }
                }
            )
        )
    }

    private func showExitError() async {
        await MainActor.run {
            AppSnackBar.show(
                title: "clubs_exit_fail".localized,
                subtitle: "common_try_again".localized,
                style: .error
            )
        }
    }

    private func assignRole(
        userId: String,
        role: AppPresentationModel.UserActivityRole
    ) async {
        do {
            try await dependencies.useCase.assignRole(
                clubId: inputData.clubId,
                userId: userId,
                role: role
            )
            await MainActor.run {
                AppSnackBar.show(title: "clubs_role_updated".localized, style: .success)
            }
            fetchData()
        } catch {
            await MainActor.run {
                AppSnackBar.show(
                    title: "clubs_role_update_fail".localized,
                    subtitle: "common_try_again".localized,
                    style: .error
                )
            }
        }
    }

    private func presentMembersList() {
        let clubId = inputData.clubId
        let useCase = dependencies.useCase
        let viewerRole = state.uiModel?.userActivityType ?? .notJoined
        let currentUserId = KeychainImpl().getString(key: .userId)
        let input = CommunitiesMemberModuleModel.MembersListInput(
            title: "clubs_members_title".localized,
            roleTitles: AppPresentationModel.UserActivityRole.localizedTitles(),
            totalCount: state.uiModel?.membersCount,
            pageSize: 20,
            loadPage: { page, size, keyword in
                try await useCase.fetchClubMembersPage(
                    id: clubId,
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
                viewerRole: viewerRole,
                activity: .clubs,
                currentUserId: currentUserId,
                onAssignRole: { userId, role in
                    do {
                        try await useCase.assignRole(clubId: clubId, userId: userId, role: role)
                        await MainActor.run { AppSnackBar.show(title: "clubs_role_updated".localized, style: .success) }
                        return true
                    } catch {
                        await MainActor.run {
                            AppSnackBar.show(title: "clubs_role_update_fail".localized, subtitle: "common_try_again".localized, style: .error)
                        }
                        return false
                    }
                },
                onReport: { _, _ in
                    await MainActor.run { AppSnackBar.show(title: "clubs_report_submitted".localized, style: .success) }
                    return true
                }
            )
        )
        Task { @MainActor in
            router.navigate(to: .membersList(input))
        }
    }
    
    private func joinClub() async {
        postEffect(.loading(true))
        defer {
            postEffect(.loading(false))
        }
        do {
            _ = try await dependencies.useCase.joinClub(id: inputData.clubId)
            await handleJoinClub()
        } catch {
            postEffect(.error(error))
        }
    }
    
    @MainActor
    private func handleJoinClub() {
        showJoinSnackBar()
        fetchData()
    }

    /// Public clubs join immediately; private clubs create a pending request.
    /// Branch the copy on the current model's access type.
    @MainActor
    private func showJoinSnackBar() {
        let name = state.uiModel?.name ?? "the club"
        if state.uiModel?.accessType == .private {
            AppSnackBar.show(
                title: "clubs_join_request_sent".localized,
                subtitle: "\(name) will review your request",
                style: .success
            )
        } else {
            AppSnackBar.show(title: "Joined \(name)", style: .success)
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
            try await dependencies.useCase.fetchClubDetails(
                clubId: inputData.clubId
            )
        }
        async let members = apiResult {
            try await dependencies.useCase.fetchClubMemberById(
                id: inputData.clubId
            )
        }
        async let events = apiResult {
            try await dependencies.eventsModule.fetchClubEvents(
                clubId: inputData.clubId,
                page: 0,
                size: 10
            )
        }

        return await .init(
            detail: detail,
            members: members,
            events: events
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

        switch results.events {
        case .success(let events):
            Task { @MainActor in
                state.eventsData = events
            }
        case .failure(let error):
            // Events tab is best-effort; surface the error but keep the rest visible.
            firstError = firstError ?? error
        }
        return firstError
    }
    
    @MainActor
    private func handleUIModel(
        _ data: ClubsDetailsModel.UIModel
    ) {
        state.uiModel = data
    }
    
    @MainActor
    private func handleMembers(
        _ data: CommunitiesMemberModuleModel.GroupedMembersData
    ) {
        state.members = data
    }
}
