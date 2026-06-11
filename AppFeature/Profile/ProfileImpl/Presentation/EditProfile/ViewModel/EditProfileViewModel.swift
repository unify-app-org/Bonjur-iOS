//
//  EditProfileViewModel.swift
//  ProfileImpl
//
//  Created by Huseyn Hasanov on 11.05.26.
//

import AppFoundation
import AppPresentationModel
import AppUtils
import AppUIKit
import Foundation
import AppNetwork

final class EditProfileViewModel: UIFeatureViewModel<EditProfileFeature> {
    
    struct Dependencies {
        let useCase: ProfileUseCase
    }
    
    private let router: EditProfileRouterProtocol
    private let inputData: EditProfileInputData
    private let dependencies: EditProfileViewModel.Dependencies
    
    init(
        state: EditProfileFeature.State,
        router: EditProfileRouterProtocol,
        inputData: EditProfileInputData,
        dependencies: EditProfileViewModel.Dependencies
    ) {
        self.router = router
        self.inputData = inputData
        self.dependencies = dependencies
        super.init(initialState: state)
    }
    
    override func handle(action: EditProfileFeature.Action) {
        switch action {
        case .fetchData:
            fetchData()
        case .selectedGender(let gender):
            state.showDatePicker = false
            state.gender = gender
        case .birthdayTapped:
            state.showDatePicker = true
        case .closeDatePicker:
            state.showDatePicker = false
        case .birthDateChanged(let date):
            state.birthDate = date
            state.birthDateText = date.toString(format: .ddMMyyyy)
        case .addCategoryTapped:
            state.showDatePicker = false
            state.showCategoryPicker = true
        case .removeCategory(let id):
            toggleCategory(with: id, selected: false)
        case .dismissCategoryPicker:
            state.showCategoryPicker = false
        case .categoryPickerDone:
            state.showCategoryPicker = false
        case .addLanguageTapped:
            state.showDatePicker = false
            state.showLanguagePicker = true
        case .removeLanguage(let id):
            toggleLanguage(with: id, selected: false)
        case .dismissLanguagePicker:
            state.showLanguagePicker = false
        case .languagePickerDone:
            state.showLanguagePicker = false
        case .saveTapped:
            Task {
                await editUser()
            }
            state.showDatePicker = false
        }
    }
    
    private func fetchData() {
        state.name = inputData.profileData.userCardModel.nameSurname
        state.faculty = inputData.profileData.userCardModel.speciality
        state.community = inputData.profileData.userCardModel.community
        state.entry = inputData.profileData.userCardModel.entryYear
        state.course = inputData.profileData.userCardModel.course
        state.about = inputData.profileData.about ?? "-"
        state.gender = inputData.profileData.gender?.type ?? .male
        state.birthDate = inputData.profileData.birthday?.convertToDate(from: .yyyyMMdd)
        state.birthDateText = state.birthDate?.toString(format: .ddMMyyyy) ?? "-"
        state.languages = selectedProfileLanguages()
        state.avatarURL = inputData.profileData.userCardModel.imageUrl
        state.bgType = inputData.profileData.userCardModel.backgroundCover ?? .primary
        
        Task {
            await fetchCategories()
            await fetchLanguages()
        }
    }
    
    private func editUser() async {
        postEffect(.loading(true))
        defer {
            postEffect(.loading(false))
        }
        do {
            let request = buildRequest()
            _ = try await dependencies.useCase.editProfile(
                multiPart: request.0,
                queryData: request.1
            )
            AppSnackBar.show(
                title: "Profile updated successfully",
                subtitle: "Your changes are saved",
                style: .success
            )
            await handleEdit()
        } catch {
            postEffect(
                .error(
                    error.localizedDescription,
                    error.detail
                )
            )
        }
    }
    
    @MainActor
    private func handleEdit() {
        router.navigate(to: .popBack)
    }
    
    private func buildRequest() -> (
        MultipartFormData?,
        ProfileDTOModel.UpdateRequest?
    ) {
        let gender = state.gender.rawValue
        let categories = state.categorySections.flatMap { item in
            return item.categories.filter({ $0.selected }).map({ $0.id })
        }
        let languages = state.languages.filter({ $0.selected }).map({ $0.id })
        let birthDate = state.birthDate?.toString(format: .yyyyMMdd)
        let bgType = state.bgType
        
        let request: ProfileDTOModel.UpdateRequest = .init(
            birthDate: birthDate,
            gender: gender,
            about: state.about,
            categoriesId: categories,
            languagesId: languages,
            background: bgType
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
    
    private func fetchCategories() async {
        do {
            let data = try await dependencies.useCase.getCategories()
            await handleCategories(data)
        } catch {
            await handleCategories([])
        }
    }
    
    @MainActor
    private func handleCategories(_ sections: [SelectCategoryView.Section]) {
        let selectedIds = Set(inputData.profileData.tags.map(\.id))
        state.categorySections = sections.map { section in
            var updatedSection = section
            updatedSection.categories = section.categories.map { category in
                var updatedCategory = category
                updatedCategory.selected = selectedIds.contains(category.id)
                return updatedCategory
            }
            return updatedSection
        }
    }
    
    private func fetchLanguages() async {
        do {
            let data = try await dependencies.useCase.getLanguages()
            await handleLanguages(data)
        } catch {
            await handleLanguages(selectedProfileLanguages())
        }
    }
    
    @MainActor
    private func handleLanguages(_ languages: [SelectableListItemView.Model]) {
        let selectedIds = Set((inputData.profileData.languages ?? []).map(\.id))
        state.languages = languages.map { language in
            var updatedLanguage = language
            updatedLanguage.selected = selectedIds.contains(language.id) || language.selected
            return updatedLanguage
        }
    }
    
    private func toggleCategory(with id: Int, selected: Bool) {
        state.categorySections = state.categorySections.map { section in
            var updatedSection = section
            updatedSection.categories = section.categories.map { category in
                var updatedCategory = category
                if category.id == id {
                    updatedCategory.selected = selected
                }
                return updatedCategory
            }
            return updatedSection
        }
    }
    
    private func toggleLanguage(with id: Int, selected: Bool) {
        state.languages = state.languages.map { language in
            var updatedLanguage = language
            if language.id == id {
                updatedLanguage.selected = selected
            }
            return updatedLanguage
        }
    }
    
    private func selectedProfileLanguages() -> [SelectableListItemView.Model] {
        (inputData.profileData.languages ?? []).map { language in
            .init(
                id: language.id,
                title: language.title,
                selected: true,
                style: .multySelect
            )
        }
    }
}
