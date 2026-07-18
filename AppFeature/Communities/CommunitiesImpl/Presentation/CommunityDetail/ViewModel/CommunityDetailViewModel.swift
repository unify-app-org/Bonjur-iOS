//
//  CommunityDetailViewModel.swift
//  CommunitiesImpl
//
//  Created by Huseyn Hasanov on 03.02.26.
//

import AppFoundation
import AppNetwork
import Communities
import Clubs
import AppUIKit
import AppStorage
import AppPresentationModel

final class CommunityDetailViewModel: UIFeatureViewModel<CommunityDetailFeature> {
    
    struct Dependencies {
        let useCase: CommunityUseCase
    }
    
    private struct InitialFetchResults {
        let detail: APIResult<CommunityDetails.UIModel>
        let members: APIResult<CommunitiesMemberModuleModel.GroupedMembersData>
        let clubs: APIResult<[ClubsModuleModel.CardInputData]>
    }
    
    private let router: CommunityDetailRouterProtocol
    private let inputData: CommunityDetailInputData
    private let dependencies: CommunityDetailViewModel.Dependencies
    
    init(
        state: CommunityDetailFeature.State,
        router: CommunityDetailRouterProtocol,
        inputData: CommunityDetailInputData,
        dependencies: CommunityDetailViewModel.Dependencies
    ) {
        self.router = router
        self.inputData = inputData
        self.dependencies = dependencies
        super.init(initialState: state)
    }
    
    override func handle(action: CommunityDetailFeature.Action) {
        switch action {
        case .backTapped:
            Task {
                await router.navigate(to: .back)
            }
        case .fetchData:
            fetchData()
        case .editTapped:
            guard let prefillData = state.uiModel?.editPrefillData else {
                return
            }
            Task {
                await router.navigate(
                    to: .edit(
                        id: inputData.communityId,
                        prefillData: prefillData
                    )
                )
            }
        case .clubItemTapped(let id):
            Task {
                await router.navigate(to: .clubsDetails(id: id))
            }
        case .userTapped(let id):
            Task {
                await router.navigate(to: .userDetails(id: id))
            }
        case .seeAllMembersTapped:
            presentMembersList()
        case .assignRole(let userId, let role):
            Task {
                await assignRole(userId: userId, role: role)
            }
        case .createClubTapped:
            Task { @MainActor in
                router.navigate(to: .createClub)
            }
        case .createEventTapped:
            Task { @MainActor in
                router.navigate(to: .createEvent)
            }
        }
    }

    private func assignRole(
        userId: String,
        role: AppPresentationModel.UserActivityRole
    ) async {
        do {
            try await dependencies.useCase.assignRole(
                communityId: inputData.communityId,
                userId: userId,
                role: role
            )
            await MainActor.run {
                AppSnackBar.show(title: "Role updated", style: .success)
            }
            fetchData()
        } catch {
            await MainActor.run {
                AppSnackBar.show(
                    title: "Could not update role",
                    subtitle: "Please try again.",
                    style: .error
                )
            }
        }
    }

    private func presentMembersList() {
        let communityId = inputData.communityId
        let useCase = dependencies.useCase
        let viewerRole = state.uiModel?.userActivity ?? .notJoined
        let currentUserId = KeychainImpl().getString(key: .userId)
        let input = CommunitiesMemberModuleModel.MembersListInput(
            title: "Members",
            titleOverrides: [.president: "Owner"],
            pageSize: 20,
            loadPage: { page, size, keyword in
                try await useCase.fetchCommunityMembersPage(
                    id: communityId,
                    page: page,
                    size: size,
                    keyword: keyword
                )
            },
            onMemberTapped: { [weak self] member in
                Task { @MainActor in
                    self?.router.navigate(to: .userDetails(id: member.id))
                }
            },
            options: .init(
                viewerRole: viewerRole,
                activity: .community,
                currentUserId: currentUserId,
                onAssignRole: { userId, role in
                    do {
                        try await useCase.assignRole(communityId: communityId, userId: userId, role: role)
                        await MainActor.run { AppSnackBar.show(title: "Role updated", style: .success) }
                        return true
                    } catch {
                        await MainActor.run {
                            AppSnackBar.show(title: "Could not update role", subtitle: "Please try again.", style: .error)
                        }
                        return false
                    }
                },
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
            try await dependencies.useCase.fetchCommunityData(
                id: inputData.communityId
            )
        }
        async let members = apiResult {
            try await dependencies.useCase.fetchCommunityMembers(
                id: inputData.communityId
            )
        }
        
        async let clubs = apiResult {
            try await dependencies.useCase.fetchClubs(
                communityId: inputData.communityId,
                query: .init(page: 0, size: 10)
            )
        }
        
        return await .init(
            detail: detail,
            members: members,
            clubs: clubs
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
        
        switch results.clubs {
        case .success(let clubs):
            Task { @MainActor in
                handleClubs(clubs)
            }
        case .failure(let error):
            firstError = firstError ?? error
        }
        return firstError
    }
    
    @MainActor
    private func handleUIModel(
        _ data: CommunityDetails.UIModel
    ) {
        state.uiModel = data
    }
    
    @MainActor
    private func handleMembers(
        _ data: CommunitiesMemberModuleModel.GroupedMembersData
    ) {
        state.membersData = data
    }
    
    @MainActor
    private func handleClubs(
        _ data: [ClubsModuleModel.CardInputData]
    ) {
        state.clubsData = data
    }
}
