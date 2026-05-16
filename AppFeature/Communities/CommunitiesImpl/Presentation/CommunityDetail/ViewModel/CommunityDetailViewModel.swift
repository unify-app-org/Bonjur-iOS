//
//  CommunityDetailViewModel.swift
//  CommunitiesImpl
//
//  Created by Huseyn Hasanov on 03.02.26.
//

import AppFoundation
import AppNetwork
import Communities

private typealias FetchResult<T> = Result<T, Error>

final class CommunityDetailViewModel: UIFeatureViewModel<CommunityDetailFeature> {
    
    struct Dependencies {
        let useCase: CommunityUseCase
    }
    
    private struct InitialFetchResults {
        let detail: FetchResult<CommunityDetails.UIModel>
        let members: FetchResult<CommunitiesMemberModuleModel.GroupedMembersData>
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
                postEffect(.error(firstError as? APIError))
            }
        }
    }
    
    private func fetchInitialData() async -> InitialFetchResults {
        async let detail = result {
            try await dependencies.useCase.fetchCommunityData(
                id: inputData.communityId
            )
        }
        async let members = result {
            try await dependencies.useCase.fetchCommunityMembers(
                id: inputData.communityId
            )
        }
        
        return await .init(
            detail: detail,
            members: members
        )
    }
    
    private func applyInitialFetchResults(
        _ results: InitialFetchResults
    ) -> Error? {
        var firstError: Error?
        
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
    
    private func result<T>(
        _ operation: () async throws -> T
    ) async -> Result<T, Error> {
        do {
            return .success(try await operation())
        } catch {
            return .failure(error)
        }
    }
}
