//
//  ClubsViewModel.swift
//  ClubsImpl
//
//  Created by Huseyn Hasanov on 17.01.26.
//

import AppFoundation

final class ClubsViewModel: UIFeatureViewModel<ClubsFeature> {
    
    struct Dependencies {
        let useCase: ClubsUseCase
    }
    
    private let router: ClubsRouterProtocol
    private let inputData: ClubsInputData
    private let dependencies: ClubsViewModel.Dependencies
    
    init(
        state: ClubsFeature.State,
        router: ClubsRouterProtocol,
        inputData: ClubsInputData,
        dependencies: ClubsViewModel.Dependencies
    ) {
        self.router = router
        self.inputData = inputData
        self.dependencies = dependencies
        super.init(initialState: state)
    }
    
    override func handle(action: ClubsFeature.Action) {
        switch action {
        case .fetchData:
            fetchData()
        }
    }
    
    private func fetchData() {
        Task {
            try await getClubs()
        }
    }
    
    private func getClubs() async throws {
        do {
            let data = try await dependencies.useCase.fetchClubsData()
            state.uiModel.clubs = data
        } catch {
            postEffect(.error(error))
        }
    }
}
