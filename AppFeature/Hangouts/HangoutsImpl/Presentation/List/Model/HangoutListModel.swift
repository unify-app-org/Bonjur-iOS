//
//  HangoutListModel.swift
//  HangoutsImpl
//
//  Created by Huseyn Hasanov on 22.01.26.
//

import AppFoundation
import AppNetwork
import AppUIKit
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
    @Published var searchText: String = ""
    
    struct UIModel {
        var hangouts: [HangoutsCardView.Model]
        var filters: [FilterView.Model] = []
    }
}

// MARK: - Feature Action

enum HangoutListAction: UIFeatureAction {
    case fetchData
    case fetchCategories
    case filtersSelected([FilterView.Items])
    case loadMore
    case searchChanged(String)
    case itemTapped(id: String)
}
