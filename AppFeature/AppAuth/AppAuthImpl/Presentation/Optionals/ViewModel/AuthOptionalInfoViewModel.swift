//
//  AuthOptionalInfoViewModel.swift
//  AppAuthImpl
//
//  Created by Huseyn Hasanov on 26.12.25.
//

import AppFoundation
import UIKit

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
        case .nextTapped:
            nextStepTapped()
        case .closeKeyboard:
            UIApplication.shared.endEditing()
        case .skipTapped:
            break
        case .previouseTapped:
            previouseTapped()
        case .closeDatePicker:
            state.showDatePicker = false
        }
    }
    
    private func previouseTapped() {
        if state.currentStep != 1 {
            state.currentStep -= 1
        } else {
            
        }
    }
    
    private func nextStepTapped() {
        if state.currentStep != state.getAllViews(store: store).count {
            state.currentStep += 1
        }
        state.showDatePicker = false
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
        state.interests = dependencies.useCase.interests()
    }
}
