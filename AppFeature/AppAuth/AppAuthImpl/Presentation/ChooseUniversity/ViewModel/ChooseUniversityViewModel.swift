//
//  ChooseUniversityViewModel.swift
//  AppAuthImpl
//
//  Created by Huseyn Hasanov on 26.12.25.
//

import AppFoundation

final class ChooseUniversityViewModel: UIFeatureViewModel<ChooseUniversityFeature> {
    
    struct Dependencies {
        let useCase: AuthUsecases
    }
    
    private let router: ChooseUniversityRouterProtocol
    private let inputData: ChooseUniversityInputData
    private let dependencies: ChooseUniversityViewModel.Dependencies
    
    init(
        state: ChooseUniversityFeature.State,
        router: ChooseUniversityRouterProtocol,
        inputData: ChooseUniversityInputData,
        dependencies: ChooseUniversityViewModel.Dependencies
    ) {
        self.router = router
        self.inputData = inputData
        self.dependencies = dependencies
        super.init(initialState: state)
    }
    
    override func handle(action: ChooseUniversityFeature.Action) {
        switch action {
        case .fetchData:
            fetchData()
        case .selectedCell(let index):
            selectedCell(index)
        case .nextTapped:
            Task {
                await router.navigate(to: .welcome)
            }
        }
    }
    
    private func fetchData() {
        Task {
            state.uiModel = try await dependencies.useCase.chooseUniversity()
        }
    }
    
    private func selectedCell(_ index: Int) {
        state.uiModel = state.uiModel.enumerated().map { (i, reason) in
            var updated = reason
            updated.selected = (i == index)
            return updated
        }
    }
}
