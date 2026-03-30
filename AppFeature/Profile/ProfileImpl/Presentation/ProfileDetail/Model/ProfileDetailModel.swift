//
//  ProfileDetailModel.swift
//  ProfileImpl
//
//  Created by Huseyn Hasanov on 04.02.26.
//

import AppFoundation
import SwiftUI
import AppUIKit

// MARK: - ProfileDetail input

struct ProfileDetailInputData {
}

// MARK: - Side effects

enum ProfileDetailSideEffect: UISideEffect {
    case loading(Bool)
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
    @Published var selectedSegment: SegmentTypes = .clubs
    
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
    case clubsItemTapped(Int)
    case eventsItemTapped(String)
    case hangoutsItemTapped(String)
    case settingsTapped
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
