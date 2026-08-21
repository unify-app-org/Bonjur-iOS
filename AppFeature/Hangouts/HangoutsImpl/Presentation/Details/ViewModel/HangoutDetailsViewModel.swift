//
//  HangoutDetailsViewModel.swift
//  HangoutsImpl
//
//  Created by Huseyn Hasanov on 02.02.26.
//

import AppFoundation
import Communities
import AppNetwork
import AppUIKit
import AppStorage
import AppPresentationModel

final class HangoutDetailsViewModel: UIFeatureViewModel<HangoutDetailsFeature> {
    
    struct Dependencies {
        let useCase: HangoutsUseCase
    }
    
    private struct InitialFetchResults {
        let detail: APIResult<HangoutDetails.UIModel>
        let members: APIResult<CommunitiesMemberModuleModel.GroupedMembersData>
    }
    
    private let router: HangoutDetailsRouterProtocol
    private let inputData: HangoutDetailsInputData
    private let dependencies: HangoutDetailsViewModel.Dependencies
    
    init(
        state: HangoutDetailsFeature.State,
        router: HangoutDetailsRouterProtocol,
        inputData: HangoutDetailsInputData,
        dependencies: HangoutDetailsViewModel.Dependencies
    ) {
        self.router = router
        self.inputData = inputData
        self.dependencies = dependencies
        super.init(initialState: state)
    }
    
    override func handle(action: HangoutDetailsFeature.Action) {
        switch action {
        case .backTapped:
            Task {
                await router.navigate(to: .back)
            }
        case .fetchData:
            fetchData()
        case .editTapped:
            editTapped()
        case .communityTapped:
            guard let communityId = state.uiModel?.communityId, communityId != 0 else { return }
            Task {
                await router.navigate(to: .communityDetail(id: communityId))
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
                await joinHangout()
            }
        }
    }

    // MARK: - Join flow

    private func joinHangout() async {
        postEffect(.loading(true))
        defer { postEffect(.loading(false)) }
        do {
            try await dependencies.useCase.joinHangout(id: inputData.hangoutId)
            await showJoinSnackBar()
            fetchData()
        } catch {
            postEffect(.error(error))
        }
    }

    /// Public hangouts join immediately; private hangouts create a pending request.
    @MainActor
    private func showJoinSnackBar() {
        let name = state.uiModel?.name ?? "the hangout"
        if state.uiModel?.accessType == .private {
            AppSnackBar.show(
                title: "hangouts_join_request_sent".localized,
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
                    title: "hangouts_exit_title".localized,
                    subtitle: "Are you sure you want to leave this hangout? You will no longer be able to participate or see updates."
                ),
                actions: {
                    AppAlert.Action(title: "hangouts_exit_confirm".localized, style: .destructive) { [weak self] in
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
                try await dependencies.useCase.exitHangout(id: inputData.hangoutId)
                await MainActor.run {
                    AppSnackBar.show(title: "hangouts_left".localized, style: .success)
                }
                await router.navigate(to: .back)
            } catch {
                await MainActor.run {
                    AppSnackBar.show(
                        title: "hangouts_exit_fail".localized,
                        subtitle: "common_try_again".localized,
                        style: .error
                    )
                }
            }
        }
    }

    private func presentMembersList() {
        let hangoutId = inputData.hangoutId
        let useCase = dependencies.useCase
        let input = CommunitiesMemberModuleModel.MembersListInput(
            title: "Members".localized,
            roleTitles: AppPresentationModel.UserActivityRole
                .localizedTitles(overriding: [.president: "hangouts_owner_role".localized]),
            totalCount: state.uiModel?.membersCount,
            pageSize: 20,
            loadPage: { page, size, keyword in
                try await useCase.fetchHangoutMembersPage(
                    id: hangoutId,
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
                activity: .hangOuts,
                currentUserId: KeychainImpl().getString(key: .userId),
                onAssignRole: { _, _ in false },
                onReport: { _, _ in
                    await MainActor.run { AppSnackBar.show(title: "hangouts_report_submitted".localized, style: .success) }
                    return true
                }
            )
        )
        Task { @MainActor in
            router.navigate(to: .membersList(input))
        }
    }
    
    private func getHangoutDetail() async {
        postEffect(.loading(true))
        defer {
            postEffect(.loading(false))
        }
        do {
            let data = try await dependencies.useCase.fetchDetailHangout(
                id: inputData.hangoutId
            )
            state.uiModel = data
        } catch {
            postEffect(.error(error))
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
            try await dependencies.useCase.fetchDetailHangout(
                id: inputData.hangoutId
            )
        }
        async let members = apiResult {
            try await dependencies.useCase.fetchDetailHangoutMembers(
                id: inputData.hangoutId
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
    private func handleUIModel(
        _ data: HangoutDetails.UIModel
    ) {
        state.uiModel = data
    }
    
    @MainActor
    private func handleMembers(
        _ data: CommunitiesMemberModuleModel.GroupedMembersData
    ) {
        state.membersData = data
    }
    
    private func editTapped() {
        guard let uiModel = state.uiModel else { return }
        Task {
            await router.navigate(
                to: .edit(
                    id: inputData.hangoutId,
                    prefillData: uiModel.editPrefillData
                )
            )
        }
    }
}
