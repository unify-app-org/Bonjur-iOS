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
    @Published var biography: String?
    @Published var birthDate: Date?
    @Published var showDatePicker: Bool = false

    struct StepItem: Identifiable {
        let id: Int
        let view: AnyView
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
