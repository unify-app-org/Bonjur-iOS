//
//  HangoutListModel.swift
//  HangoutsImpl
//
//  Created by Huseyn Hasanov on 22.01.26.
//

import AppFoundation
import AppNetwork
import Combine

// MARK: - HangoutList input

struct HangoutListInputData {
}

// MARK: - Side effects

enum HangoutListSideEffect: UISideEffect {
    case loading(Bool)
    case error(APIError)
}

// MARK: - Feature Definition

typealias HangoutListFeature = UIFeatureDefinition<
    HangoutListViewState,
    HangoutListAction,
    HangoutListSideEffect
>

// MARK: - View State

final class HangoutListViewState: UIFeatureState {
    @Published var uiModel: UIModel = .init(hangouts: [])
    
    struct UIModel {
        var hangouts: [HangoutsCardView.Model]
    }
}

// MARK: - Feature Action

enum HangoutListAction: UIFeatureAction {
    case fetchData
}
