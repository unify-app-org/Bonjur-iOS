//
//  ClubCreateViewModel.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 21.02.26.
//

import AppFoundation

final class ClubCreateViewModel: UIFeatureViewModel<ClubCreateFeature> {
    
    struct Dependencies {
        let useCase: ClubsUseCase
    }
    
    private let router: ClubCreateRouterProtocol
    private let inputData: ClubCreateInputData
    private let dependencies: ClubCreateViewModel.Dependencies
    
    init(
        state: ClubCreateFeature.State,
        router: ClubCreateRouterProtocol,
        inputData: ClubCreateInputData,
        dependencies: ClubCreateViewModel.Dependencies
    ) {
        self.router = router
        self.inputData = inputData
        self.dependencies = dependencies
        super.init(initialState: state)
    }
    
    override func handle(action: ClubCreateFeature.Action) {
        switch action {
        case .backTapped:
            break
        case .fetchData:
            fetchData()
        }
    }
    
    private func fetchData() {
        Task {
            await fetchCreate()
        }
    }
    
    private func fetchCreate() async {
        do {
            let data = try await dependencies.useCase.fetchCreateFields()
            state.clubsCreateSchema = data
        } catch { }
    }
    
    
}
