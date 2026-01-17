//
//  ClubsModel.swift
//  ClubsImpl
//
//  Created by Huseyn Hasanov on 17.01.26.
//

import AppFoundation

// MARK: - Clubs input

struct ClubsInputData {
}

// MARK: - Side effects

enum ClubsSideEffect: UISideEffect {
    case loading(Bool)
}

// MARK: - Feature Definition

typealias ClubsFeature = UIFeatureDefinition<
    ClubsViewState,
    ClubsAction,
    ClubsSideEffect
>

// MARK: - View State

final class ClubsViewState: UIFeatureState {
}

// MARK: - Feature Action

enum ClubsAction: UIFeatureAction {
}
