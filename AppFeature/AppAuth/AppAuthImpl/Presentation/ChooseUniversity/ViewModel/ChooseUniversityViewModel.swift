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
        case .selectedCell(let id):
            selectedCell(id)
        case .nextTapped:
            nextTapped()
        }
    }
    
    private func fetchData() {
        Task {
            state.uiModel = try await dependencies.useCase.chooseUniversity()
        }
    }
    
    private func nextTapped() {
        let selectedItem = state.uiModel.first(where: { $0.selected == true })
        if selectedItem?.id == 1 {
            Task {
                await router.navigate(to: .welcome)
            }
        } else {
            Task {
                await router.navigate(to: .signIn)
            }
        }
    }
    
    private func selectedCell(_ id: Int) {
        state.uiModel = state.uiModel.map { reason in
            var updated = reason
            updated.selected = (reason.id == id)
            return updated
        }
    }
}
