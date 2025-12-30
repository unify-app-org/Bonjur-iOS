//
//  AuthOptionalInfoModel.swift
//  AppAuthImpl
//
//  Created by Huseyn Hasanov on 26.12.25.
//

import AppFoundation
import SwiftUICore
import AppUIKit

// MARK: - AuthOptionalInfo input

struct AuthOptionalInfoInputData {
}

// MARK: - Side effects

enum AuthOptionalInfoSideEffect: UISideEffect {
    case loading(Bool)
}

// MARK: - Feature Definition

typealias AuthOptionalInfoFeature = UIFeatureDefinition<
    AuthOptionalInfoViewState,
    AuthOptionalInfoAction,
    AuthOptionalInfoSideEffect
>

// MARK: - View State

final class AuthOptionalInfoViewState: UIFeatureState {
    @Published var currentStep: Int = 1
    @Published var langauges: [SelectableListItemView.Model] = []
    @Published var genders: [SelectableListItemView.Model] = []
    @Published var interests: [AuthInterestsModel] = []
    @Published var biography: String?
    @Published var birthDate: Date?
    @Published var showDatePicker: Bool = false
    @Published var selectedImage: Data?
    struct StepItem: Identifiable {
        let id: Int
        let view: AnyView
    }
    
    func getAllViews(
        store: StoreOf<AuthOptionalInfoFeature>
    ) -> [AuthOptionalInfoViewState.StepItem] {
        [
            .init(
                id: 1,
                view: AnyView(
                    AuthOptionalBirthdayView()
                        .environmentObject(store)
                )
            ),
            .init(
                id: 2,
                view: AnyView(
                    AuthOptionalSelectGenderView()
                        .environmentObject(store)
                )
            ),
            .init(
                id: 3,
                view: AnyView(
                    AuthOptionalSelectLanguageView()
                        .environmentObject(store)
                )
            ),
            .init(
                id: 4,
                view: AnyView(
                    AuthOptionalBioView()
                        .environmentObject(store)
                )
            ),
            .init(
                id: 5,
                view: AnyView(
                    AuthOptionalInterestsView()
                        .environmentObject(store)
                )
            ),
            .init(
                id: 6,
                view: AnyView(
                    AuthOptionalUploadPhotoView()
                        .environmentObject(store)
                )
            )
        ]
    }
}

// MARK: - Feature Action

enum AuthOptionalInfoAction: UIFeatureAction {
    case fetchData
    case selectedGender(Int)
    case selectedLanguage(Int)
    case nextTapped
    case closeKeyboard
    case closeDatePicker
    case previouseTapped
    case skipTapped
}
