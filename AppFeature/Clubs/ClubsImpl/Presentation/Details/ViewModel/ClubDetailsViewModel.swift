//
//  ClubDetailsViewModel.swift
//  AppAuth
//
//  Created by Huseyn Hasanov on 29.01.26.
//

import AppFoundation

final class ClubDetailsViewModel: UIFeatureViewModel<ClubDetailsFeature> {
    
    struct Dependencies {
        let useCase: ClubsUseCase
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
            Task {
                await router.navigate(to: .backTapped)
            }
        }
    }
    
    private func fetchData() {
        Task {
            await fetchUIModel()
        }
    }
    
    private func fetchUIModel() async {
        do {
            let uiModel = try await dependencies.useCase.fetchClubDetails(
                clubId: inputData.clubId
            )
            state.uiModel = uiModel
        } catch {
            
        }
    }
}
