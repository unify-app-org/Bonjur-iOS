//
//  AuthOptionalInfoViewModel.swift
//  AppAuthImpl
//
//  Created by Huseyn Hasanov on 26.12.25.
//

import UIKit
import AppNetwork
import AppFoundation
import AppUIKit
import AppUtils

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
            skipTapped()
        case .previouseTapped:
            previouseTapped()
        case .closeDatePicker:
            state.showDatePicker = false
        }
    }
    
    private func fetchData() {
        Task {
            await fetchCategories()
            await fetchLanguages()
            state.genders = dependencies.useCase.genders()
        }
    }
    
    private func fetchCategories() async {
        do {
            let data = try await dependencies.useCase.interests()
            await handleCategories(data)
        } catch {
            postEffect(
                .error(
                    title: error.localizedDescription,
                    subtitle: error.localizedDescription
                )
            )
        }
    }
    
    @MainActor
    private func handleCategories(
        _ data: [AuthUIModel.Interests]
    ) {
        state.interests = data
    }
    
    private func fetchLanguages() async {
        do {
            let data = try await dependencies.useCase.getLanguages()
            await handleLanguage(data)
        } catch {
            postEffect(
                .error(
                    title: error.localizedDescription,
                    subtitle: error.detail
                )
            )
        }
    }
    
    @MainActor
    private func handleLanguage(
        _ data: [SelectableListItemView.Model]
    ) {
        state.langauges = data
    }
    
    private func skipTapped() {
        Task {
           await sendOptionals()
       }
    }
    
    private func buildRequest() -> (
        MultipartFormData?,
        AuthDTOModel.OptionalsQuery?
    ) {
        let gender = state.genders.first(where: { $0.selected })?.type
        let categories = state.interests.flatMap { item in
            return item.interests.filter({ $0.selected }).map({ $0.id })
        }
        let languages = state.langauges.filter({ $0.selected }).map({ $0.id })
        let birthDate = state.birthDate?.toString(format: .yyyyMMdd)
        
        let request: AuthDTOModel.OptionalsQuery = .init(
            birthDate: birthDate,
            gender: gender,
            about: state.biography,
            categoriesId: categories,
            languagesId: languages
        )
        guard let image = state.selectedImage else {
            return (nil, request)
        }
        var formData = MultipartFormData()
        formData.addFile(
            name: "file",
            fileName: "avatar.jpg",
            mimeType: "image/jpeg",
            data: image
        )
        return (formData, request)
    }
    
    private func sendOptionals() async {
        postEffect(.loading(true))
        do {
            let request = buildRequest()
            let _ = try await dependencies.useCase.sendOptionals(
                multiPart: request.0,
                queryData: request.1
            )
            postEffect(.loading(false))
            await handleSendOptionals()
        } catch {
            postEffect(.loading(false))
            await handleSendOptionals()
        }
    }
    
    @MainActor
    private func handleSendOptionals() {
        router.navigate(to: .skip)
    }
    
    private func previouseTapped() {
        if state.currentStep != 1 {
            state.currentStep -= 1
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
        } else {
            skipTapped()
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
}
