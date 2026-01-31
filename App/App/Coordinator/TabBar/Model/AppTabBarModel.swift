//
//  AppTabBarModel.swift
//  App
//
//  Created by Huseyn Hasanov on 01.01.26.
//  Copyright © 2026 Unify. All rights reserved.
//

import AppFoundation

// MARK: - AppTabBar input

struct AppTabBarInputData {
}

// MARK: - Side effects

enum AppTabBarSideEffect: UISideEffect {
    case loading(Bool)
}

// MARK: - Feature Definition

typealias AppTabBarFeature = UIFeatureDefinition<
    AppTabBarViewState,
    AppTabBarAction,
    AppTabBarSideEffect
>

// MARK: - View State

final class AppTabBarViewState: UIFeatureState {
}

// MARK: - Feature Action

enum AppTabBarAction: UIFeatureAction {
}
