//
//  RegisterModel.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 25.11.25.
//

import Combine
import AppFoundation
import AppNetwork

// MARK: - Feature Definition

typealias RegisterFeature = UIFeatureDefinition<
    RegisterViewState,
    RegisterAction,
    RegisterEffect
>

// MARK: - State

final class RegisterViewState: UIFeatureState {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""

    var isFormValid: Bool {
        !email.isEmpty &&
        password.count >= 6 &&
        email.contains("@")
    }
}

// MARK: - Actions

enum RegisterAction: UIFeatureAction {
    case registerTapped
    case fetchData
}

// MARK: - Effects

enum RegisterEffect: UISideEffect {
    case loading(Bool)
    case showError(APIError)
}

// MARK: - InputData

struct RegisterInputData { }
