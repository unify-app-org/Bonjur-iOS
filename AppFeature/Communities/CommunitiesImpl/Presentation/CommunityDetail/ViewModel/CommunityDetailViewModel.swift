//
//  CommunityDetailViewModel.swift
//  CommunitiesImpl
//
//  Created by Huseyn Hasanov on 03.02.26.
//

import AppFoundation

final class CommunityDetailViewModel: UIFeatureViewModel<CommunityDetailFeature> {
    
    struct Dependencies {
        let useCase: CommunityUseCase
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
        }
    }
    
    private func fetchData() {
        Task {
            await getCommunityDetail()
        }
    }
    
    private func getCommunityDetail() async {
        do {
            let data = try await dependencies.useCase.fetchCommunityData(id: inputData.communityId)
            state.uiModel = data
        } catch {
            
        }
    }
}
