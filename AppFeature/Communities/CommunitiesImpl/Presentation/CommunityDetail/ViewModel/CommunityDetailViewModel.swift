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
