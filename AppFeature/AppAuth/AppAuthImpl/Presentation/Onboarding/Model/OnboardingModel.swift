//
//  OnboardingModel.swift
//  AppAuth
//
//  Created by Huseyn Hasanov on 23.12.25.
//

import AppFoundation
import Combine

// MARK: - Onboarding input

struct OnboardingInputData {
}

// MARK: - Side effects

enum OnboardingSideEffect: UISideEffect {
    case loading(Bool)
}

// MARK: - Feature Definition

typealias OnboardingFeature = UIFeatureDefinition<
    OnboardingViewState,
    OnboardingAction,
    OnboardingSideEffect
>

// MARK: - View State

final class OnboardingViewState: UIFeatureState {
    @Published var uiModel: [OnboardingUIModel] = []
}

// MARK: - Feature Action

enum OnboardingAction: UIFeatureAction {
    case fetchData
    case skipOnboarding
}
