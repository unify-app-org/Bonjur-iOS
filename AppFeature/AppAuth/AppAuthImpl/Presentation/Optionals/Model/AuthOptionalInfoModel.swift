//
//  AuthOptionalInfoModel.swift
//  AppAuthImpl
//
//  Created by Huseyn Hasanov on 26.12.25.
//

import AppFoundation

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
}

// MARK: - Feature Action

enum AuthOptionalInfoAction: UIFeatureAction {
}
