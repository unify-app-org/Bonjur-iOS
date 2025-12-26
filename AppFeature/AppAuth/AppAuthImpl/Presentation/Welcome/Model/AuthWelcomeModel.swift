//
//  AuthWelcomeModel.swift
//  AppAuthImpl
//
//  Created by Huseyn Hasanov on 26.12.25.
//

import AppFoundation
import Combine
import AppUIKit
import UIKit

// MARK: - AuthWelcome input

struct AuthWelcomeInputData {
    let name: String
}

// MARK: - Side effects

enum AuthWelcomeSideEffect: UISideEffect {
    case loading(Bool)
}

// MARK: - Feature Definition

typealias AuthWelcomeFeature = UIFeatureDefinition<
    AuthWelcomeViewState,
    AuthWelcomeAction,
    AuthWelcomeSideEffect
>

// MARK: - View State

final class AuthWelcomeViewState: UIFeatureState {
    @Published var uiModel: OnboardingUIModel = .init(
        title: "",
        subtitle: "",
        image: UIImage.Icons.bigResume
    )
}

// MARK: - Feature Action

enum AuthWelcomeAction: UIFeatureAction {
    case fetchData
    case dismiss
    case continueTapped
}
