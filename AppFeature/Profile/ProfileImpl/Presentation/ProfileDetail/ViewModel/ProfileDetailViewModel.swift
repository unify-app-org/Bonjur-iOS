//
//  ProfileDetailViewModel.swift
//  ProfileImpl
//
//  Created by Huseyn Hasanov on 04.02.26.
//

import AppFoundation

final class ProfileDetailViewModel: UIFeatureViewModel<ProfileDetailFeature> {
    
    struct Dependencies {
        let useCase: ProfileUseCase
    }
    
    private let router: ProfileDetailRouterProtocol
    private let inputData: ProfileDetailInputData
    private let dependencies: ProfileDetailViewModel.Dependencies
    
    init(
        state: ProfileDetailFeature.State,
        router: ProfileDetailRouterProtocol,
        inputData: ProfileDetailInputData,
        dependencies: ProfileDetailViewModel.Dependencies
    ) {
        self.router = router
        self.inputData = inputData
        self.dependencies = dependencies
        super.init(initialState: state)
    }
    
    override func handle(action: ProfileDetailFeature.Action) {
        switch action {
        case .fetchData:
            fetchData()
        case .clubsItemTapped(let id):
            Task {
                await router.navigate(to: .clubsDetails(id: id))
            }
        case .eventsItemTapped(let id):
            Task {
                await router.navigate(to: .eventsDetails(id: id))
            }
        case .hangoutsItemTapped(let id):
            Task {
                await router.navigate(to: .hangoutsDetails(id: id))
            }
        }
    }
    
    private func fetchData() {
        Task {
            await fetchUserData()
        }
    }
    
    private func fetchUserData() async {
        do {
            state.uiModel = try await dependencies.useCase.getProfileData()
        } catch {
            
        }
    }
}
