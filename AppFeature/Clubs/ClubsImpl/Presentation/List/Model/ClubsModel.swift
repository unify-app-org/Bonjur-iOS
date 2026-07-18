//
//  ClubsModel.swift
//  ClubsImpl
//
//  Created by Huseyn Hasanov on 17.01.26.
//

import AppFoundation
import Combine
import AppNetwork
import AppUIKit

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
    @Published var searchText: String = ""

    struct UIModel {
        var clubs: [ClubCardView.Model] = []
        var filters: [FilterView.Model] = []
    }
}

// MARK: - Feature Action

enum ClubsAction: UIFeatureAction {
    case fetchData
    case fetchCategories
    case filtersSelected([FilterView.Items])
    case loadMore
    case searchChanged(String)
    case itemOnTap(id: Int)
    case createTapped
}
