//
//  EditProfileModel.swift
//  ProfileImpl
//
//  Created by Huseyn Hasanov on 11.05.26.
//

import Combine
import AppFoundation
import AppPresentationModel
import AppUIKit
import Foundation

// MARK: - EditProfile input

struct EditProfileInputData {
    let profileData: ProfileDetail.UIModel
}

// MARK: - Side effects

enum EditProfileSideEffect: UISideEffect {
    case loading(Bool)
    case error(String, String?)
}

// MARK: - Feature Definition

typealias EditProfileFeature = UIFeatureDefinition<
    EditProfileViewState,
    EditProfileAction,
    EditProfileSideEffect
>

// MARK: - View State

final class EditProfileViewState: UIFeatureState {
    
    @Published var name: String = "-"
    @Published var faculty: String = "-"
    @Published var community: String = "-"
    @Published var entry: String = "-"
    @Published var course: String = "-"
    
    @Published var about: String = "-"
    @Published var birthDate: Date?
    @Published var birthDateText: String = ""
    @Published var showDatePicker: Bool = false
    @Published var showCategoryPicker: Bool = false
    @Published var showLanguagePicker: Bool = false
    
    @Published var gender: AppPresentationModel.Gender = .male
    @Published var bgType: AppPresentationModel.BackgroundType = .primary
    @Published var categorySections: [SelectCategoryView.Section] = []
    @Published var languages: [SelectableListItemView.Model] = []

    @Published var avatarURL: URL?
    @Published var selectedImage: Data?
    
    var selectedCategories: [CategoriesChipsView.Model] {
        categorySections
            .flatMap(\.categories)
            .filter(\.selected)
    }
    
    var selectedLanguages: [SelectionFieldItem] {
        languages
            .filter(\.selected)
            .map {
                SelectionFieldItem(
                    id: $0.id,
                    title: $0.title
                )
            }
    }
}

// MARK: - Feature Action

enum EditProfileAction: UIFeatureAction {
    case fetchData
    case selectedGender(AppPresentationModel.Gender)
    case birthdayTapped
    case closeDatePicker
    case birthDateChanged(Date)
    case addCategoryTapped
    case removeCategory(Int)
    case dismissCategoryPicker
    case categoryPickerDone
    case addLanguageTapped
    case removeLanguage(Int)
    case dismissLanguagePicker
    case languagePickerDone
    case saveTapped
}
