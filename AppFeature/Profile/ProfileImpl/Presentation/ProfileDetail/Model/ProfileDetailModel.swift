//
//  ProfileDetailModel.swift
//  ProfileImpl
//
//  Created by Huseyn Hasanov on 04.02.26.
//

import AppPresentationModel
import AppFoundation
import SwiftUI
import AppUIKit
import Hangouts
import Events
import Clubs

// MARK: - ProfileDetail input

struct ProfileDetailInputData {
    let userId: String?
    /// Community the profile is being viewed inside; nil falls back to the one stored at
    /// login. Only a community detail sets this.
    var communityId: Int? = nil
}

// MARK: - Side effects

enum ProfileDetailSideEffect: UISideEffect {
    case loading(Bool)
    case error(String, String?)
}

// MARK: - Feature Definition

typealias ProfileDetailFeature = UIFeatureDefinition<
    ProfileDetailViewState,
    ProfileDetailAction,
    ProfileDetailSideEffect
>

// MARK: - View State

final class ProfileDetailViewState: UIFeatureState {
    @Published var uiModel: ProfileDetail.UIModel?
    @Published var clubs: [ClubsModuleModel.CardInputData] = []
    @Published var events: [EventsModuleModel.CardInputData] = []
    @Published var hangouts: [HangoutsModuleModel.CardInputData] = []
    @Published var selectedSegment: SegmentTypes = .clubs
    @Published var navigationTitle = "profile_title".localized
    @Published var isOtherUser = false
    
    enum SegmentTypes: String, CaseIterable, Identifiable {
        case clubs = "Clubs"
        case events = "Events"
        case hangouts = "Hangouts"
        
        var id: Self { self }
    }
}

// MARK: - Feature Action

enum ProfileDetailAction: UIFeatureAction {
    case fetchData
    case editProfile
    case clubsItemTapped(Int)
    case eventsItemTapped(String)
    case hangoutsItemTapped(String)
    case settingsTapped
    case activitiesTapped
    case userCardTapped
    case userCardCoverSaved(AppUIEntities.BackgroundType?)
}


// MARK: - PreferenceKey

struct TabHeightPreferenceKey: PreferenceKey {
    static var defaultValue: [ProfileDetailViewState.SegmentTypes: CGFloat] = [:]
    
    static func reduce(value: inout [ProfileDetailViewState.SegmentTypes: CGFloat], nextValue: () -> [ProfileDetailViewState.SegmentTypes: CGFloat]) {
        value.merge(nextValue()) { _, new in new }
    }
}
