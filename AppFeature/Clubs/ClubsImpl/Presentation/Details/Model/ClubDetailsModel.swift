//
//  ClubDetailsModel.swift
//  AppAuth
//
//  Created by Huseyn Hasanov on 29.01.26.
//

import AppFoundation

// MARK: - ClubDetails input

struct ClubDetailsInputData {
}

// MARK: - Side effects

enum ClubDetailsSideEffect: UISideEffect {
    case loading(Bool)
}

// MARK: - Feature Definition

typealias ClubDetailsFeature = UIFeatureDefinition<
    ClubDetailsViewState,
    ClubDetailsAction,
    ClubDetailsSideEffect
>

// MARK: - View State

final class ClubDetailsViewState: UIFeatureState {
}

// MARK: - Feature Action

enum ClubDetailsAction: UIFeatureAction {
}
