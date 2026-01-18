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
    @Published var currentCommunitiesPage = 0
    
    struct UIModel {
        var user: UserModel
        var filters: [FilterView.Model]
        var communities: [CommunityCardView.Model]
        var clubs: [ClubCardView.Model]
        var events: [EventsCardView.Model]
        var hangouts: [HangoutsCardView.Model]
    }
}

// MARK: - Feature Action

enum DiscoverAction: UIFeatureAction {
    case fetchData
    case viewAllTapped(AppUIEntities.ActivityType)
}
