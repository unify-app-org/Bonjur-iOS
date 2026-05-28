//
//  CommunityDetailModel.swift
//  CommunitiesImpl
//
//  Created by Huseyn Hasanov on 03.02.26.
//

import AppFoundation
import SwiftUI
import Clubs
import Communities
import AppNetwork

// MARK: - CommunityDetail input

struct CommunityDetailInputData {
    let communityId: Int
}

// MARK: - Side effects

enum CommunityDetailSideEffect: UISideEffect {
    case loading(Bool)
    case error(APIError?)
}

// MARK: - Feature Definition

typealias CommunityDetailFeature = UIFeatureDefinition<
    CommunityDetailViewState,
    CommunityDetailAction,
    CommunityDetailSideEffect
>

// MARK: - View State

final class CommunityDetailViewState: UIFeatureState {
    
    @Published var uiModel: CommunityDetails.UIModel?
    @Published var selectedSegment: SegmentTypes = .about
    @Published var clubsData: [ClubsModuleModel.CardInputData] = []
    @Published var membersData: CommunitiesMemberModuleModel.GroupedMembersData?
    @Published var joinButtonTitle: String = "Join"
    
    var isEditable: Bool {
        uiModel?.userActivity == .visePresident || uiModel?.userActivity == .president
    }
    var canCreateEvent: Bool {
        uiModel?.userActivity != .member && uiModel?.userActivity != .notJoined
    }
    var hasJoined: Bool {
        uiModel?.userActivity != .notJoined
    }
    
    enum SegmentTypes: String, CaseIterable, Identifiable {
        case about = "About"
        case clubs = "Clubs"
        case members = "Members"
        
        var id: Self { self }
    }
}

// MARK: - Feature Action

enum CommunityDetailAction: UIFeatureAction {
    case fetchData
    case backTapped
    case editTapped
    case clubItemTapped(Int)
    case userTapped(String)
}

// MARK: - PreferenceKey

struct TabHeightPreferenceKey: PreferenceKey {
    static var defaultValue: [CommunityDetailViewState.SegmentTypes: CGFloat] = [:]
    
    static func reduce(value: inout [CommunityDetailViewState.SegmentTypes: CGFloat], nextValue: () -> [CommunityDetailViewState.SegmentTypes: CGFloat]) {
        value.merge(nextValue()) { _, new in new }
    }
}
