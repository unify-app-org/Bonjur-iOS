//
//  AuthOptionalInfoViewModel.swift
//  AppAuthImpl
//
//  Created by Huseyn Hasanov on 26.12.25.
//

import AppFoundation

final class AuthOptionalInfoViewModel: UIFeatureViewModel<AuthOptionalInfoFeature> {
    
    struct Dependencies {
        let useCase: AuthUsecases
    }
    
    private let router: AuthOptionalInfoRouterProtocol
    private let inputData: AuthOptionalInfoInputData
    private let dependencies: AuthOptionalInfoViewModel.Dependencies
    
    init(
        state: AuthOptionalInfoFeature.State,
        router: AuthOptionalInfoRouterProtocol,
        inputData: AuthOptionalInfoInputData,
        dependencies: AuthOptionalInfoViewModel.Dependencies
    ) {
        self.router = router
        self.inputData = inputData
        self.dependencies = dependencies
        super.init(initialState: state)
    }
    
    override func handle(action: AuthOptionalInfoFeature.Action) {
        switch action {
        case .fetchData:
            fetchData()
        case .selectedGender(let index):
            selectGender(at: index)
        case .selectedLanguage(let index):
            selectLanguage(at: index)
        }
    }
    
    private func selectGender(at index: Int) {
        state.genders = state.genders.enumerated().map { (i, gender) in
            var updated = gender
            updated.selected = (i == index)
            return updated
        }
    }
    
    private func selectLanguage(at index: Int) {
        state.langauges = state.langauges.enumerated().map { (i, language) in
            var updated = language
            if i == index {
                updated.selected.toggle()
            }
            return updated
        }
    }
    
    private func fetchData() {
        state.genders = dependencies.useCase.genders()
        state.langauges = dependencies.useCase.languages()
    }
}
