//
//  DiscoverModel.swift
//  DiscoverImpl
//
//  Created by Huseyn Hasanov on 11.01.26.
//

import AppFoundation
import AppUIKit
import Combine
import AppNetwork
import Clubs
import Events
import Hangouts
import Communities

// MARK: - Discover input

struct DiscoverInputData {
}

// MARK: - Side effects

enum DiscoverSideEffect: UISideEffect {
    case loading(Bool)
    case error(APIError)
}

// MARK: - Feature Definition

typealias DiscoverFeature = UIFeatureDefinition<
    DiscoverViewState,
    DiscoverAction,
    DiscoverSideEffect
>

// MARK: - View State

final class DiscoverViewState: UIFeatureState {
    @Published var uiModel: UIModel = .init(
        user: .init(id: 1, name: "", profileImage: nil, greeting: ""),
        filters: [],
        communities: [],
        clubs: [],
        events: [],
        hangouts: []
    )
    
    struct UIModel {
        var user: UserModel
        var filters: [FilterView.Model]
        var communities: [CommunitiesModuleModel.CardInputData]
        var clubs: [ClubsModuleModel.CardInputData]
        var events: [EventsModuleModel.CardInputData]
        var hangouts: [HangoutsModuleModel.CardInputData]
    }
}

// MARK: - Feature Action

enum DiscoverAction: UIFeatureAction {
    case fetchData
    case profileTapped
    case viewAllTapped(AppUIEntities.ActivityType)
    case clubItemOnTap(id: Int)
    case eventItemOnTap(id: String)
    case hangoutsItemOnTap(id: String)
    case communityItemOnTap(id: Int)
}
