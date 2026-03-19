//
//  SignInModel.swift
//  AppAuthImpl
//
//  Created by Huseyn Hasanov on 06.01.26.
//

import AppFoundation
import Combine
import SwiftUI
import AppUIKit

// MARK: - SignIn input

struct SignInInputData {
}

// MARK: - Side effects

enum SignInSideEffect: UISideEffect {
    case loading(Bool)
}

// MARK: - Feature Definition

typealias SignInFeature = UIFeatureDefinition<
    SignInViewState,
    SignInAction,
    SignInSideEffect
>

// MARK: - View State

final class SignInViewState: UIFeatureState {
    @Published var error: AppAlert.Config? = nil
    
    @Published var email: String = ""
    @Published var password: String = ""
    
    var isValid: Bool {
        !email.isEmpty && !password.isEmpty
    }
}

// MARK: - Feature Action

enum SignInAction: UIFeatureAction {
    case signIn
    case fetchData
}
