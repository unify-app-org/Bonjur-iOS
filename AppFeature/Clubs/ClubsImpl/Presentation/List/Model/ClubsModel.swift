//
//  ClubsModel.swift
//  ClubsImpl
//
//  Created by Huseyn Hasanov on 17.01.26.
//

import AppFoundation
import Combine
import AppNetwork

// MARK: - Clubs input

struct ClubsInputData {
}

// MARK: - Side effects

enum ClubsSideEffect: UISideEffect {
    case loading(Bool)
    case error(APIError)
}

// MARK: - Feature Definition

typealias ClubsFeature = UIFeatureDefinition<
    ClubsViewState,
    ClubsAction,
    ClubsSideEffect
>

// MARK: - View State

final class ClubsViewState: UIFeatureState {
    @Published var uiModel: UIModel = .init()
    
    struct UIModel {
        var clubs: [ClubCardView.Model] = []
    }
}

// MARK: - Feature Action

enum ClubsAction: UIFeatureAction {
    case fetchData
}
