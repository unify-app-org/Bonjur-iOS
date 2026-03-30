//
//  ProfileSettingsModel.swift
//  AppFeature
//
//  Created by Nahid Askerli on 26.02.26.
//

import AppFoundation

// MARK: - ProfileSettings input

struct ProfileSettingsInputData {
}

// MARK: - Side effects

enum ProfileSettingsSideEffect: UISideEffect {
    case loading(Bool)
}

// MARK: - Feature Definition

typealias ProfileSettingsFeature = UIFeatureDefinition<
    ProfileSettingsViewState,
    ProfileSettingsAction,
    ProfileSettingsSideEffect
>

// MARK: - View State

final class ProfileSettingsViewState: UIFeatureState {
}

// MARK: - Feature Action

enum ProfileSettingsAction: UIFeatureAction {
}
