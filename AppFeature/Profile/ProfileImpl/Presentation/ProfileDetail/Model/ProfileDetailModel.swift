//
//  ProfileDetailModel.swift
//  ProfileImpl
//
//  Created by Huseyn Hasanov on 04.02.26.
//

import AppFoundation

// MARK: - ProfileDetail input

struct ProfileDetailInputData {
}

// MARK: - Side effects

enum ProfileDetailSideEffect: UISideEffect {
    case loading(Bool)
}

// MARK: - Feature Definition

typealias ProfileDetailFeature = UIFeatureDefinition<
    ProfileDetailViewState,
    ProfileDetailAction,
    ProfileDetailSideEffect
>

// MARK: - View State

final class ProfileDetailViewState: UIFeatureState {
}

// MARK: - Feature Action

enum ProfileDetailAction: UIFeatureAction {
}
