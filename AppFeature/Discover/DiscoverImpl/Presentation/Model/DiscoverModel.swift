//
//  DiscoverModel.swift
//  DiscoverImpl
//
//  Created by Huseyn Hasanov on 11.01.26.
//

import AppFoundation

// MARK: - Discover input

struct DiscoverInputData {
}

// MARK: - Side effects

enum DiscoverSideEffect: UISideEffect {
    case loading(Bool)
}

// MARK: - Feature Definition

typealias DiscoverFeature = UIFeatureDefinition<
    DiscoverViewState,
    DiscoverAction,
    DiscoverSideEffect
>

// MARK: - View State

final class DiscoverViewState: UIFeatureState {
}

// MARK: - Feature Action

enum DiscoverAction: UIFeatureAction {
}
