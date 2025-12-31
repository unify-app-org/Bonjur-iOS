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
        case .selectedGender(let id):
            selectGender(id)
        case .selectedLanguage(let id):
            selectLanguage(id)
        case .selectedInterest(let id):
            selectedInterest(id)
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
    
    private func selectedInterest(_ id: Int) {
        state.interests = state.interests.map { interest in
            var updated = interest
            updated.interests = updated.interests.map { category in
                var updatedCategory = category
                if category.id == id {
                    updatedCategory.selected.toggle()
                }
                return updatedCategory
            }
            return updated
        }
    }
    
    private func nextStepTapped() {
        if state.currentStep != state.getAllViews(store: store).count {
            state.currentStep += 1
        }
        state.showDatePicker = false
    }
    
    private func selectGender(_ id: Int) {
        state.genders = state.genders.map { gender in
            var updated = gender
            updated.selected = (gender.id == id)
            return updated
        }
    }
    
    private func selectLanguage(_ id: Int) {
        state.langauges = state.langauges.map { language in
            var updated = language
            if language.id == id {
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
