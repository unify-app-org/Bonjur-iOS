//
//  ClubDetailsModel.swift
//  AppAuth
//
//  Created by Huseyn Hasanov on 29.01.26.
//

import AppFoundation
import SwiftUI
import Events
import AppUIKit
import Communities
import AppNetwork
import AppPresentationModel

// MARK: - ClubDetails input

struct ClubDetailsInputData {
    let clubId: Int
}

// MARK: - Side effects

enum ClubDetailsSideEffect: UISideEffect {
    case loading(Bool)
    case error(APIError?)
}

// MARK: - Feature Definition

typealias ClubDetailsFeature = UIFeatureDefinition<
    ClubDetailsViewState,
    ClubDetailsAction,
    ClubDetailsSideEffect
>

// MARK: - View State

final class ClubDetailsViewState: UIFeatureState {
    
    @Published var uiModel: ClubsDetailsModel.UIModel?
    @Published var members: CommunitiesMemberModuleModel.GroupedMembersData?
    @Published var eventsData: [EventsModuleModel.CardInputData] = []
    @Published var eventsHasMore = false
    @Published var selectedSegment: SegmentTypes = .about
    
    var isEditable: Bool {
        uiModel?.userActivityType == .visePresident || uiModel?.userActivityType == .president
    }
    var canCreateEvent: Bool {
        uiModel?.userActivityType != .member && uiModel?.userActivityType != .notJoined
    }
    var isPrivate: Bool {
        uiModel?.accessType == .private
    }
    var isVerified: Bool {
        uiModel?.clubStatus?.isVerified ?? false
    }
    /// Request-verify button: club admins only, and only while the club isn't verified.
    var showVerifyButton: Bool {
        isEditable && !isVerified
    }
    /// A pending verification request keeps the button visible but disabled.
    var verifyButtonDisabled: Bool {
        uiModel?.clubStatus == .pending
    }
    
    enum SegmentTypes: String, CaseIterable, Identifiable {
        case about = "About"
        case events = "Events"
        case members = "Members"
        
        var id: Self { self }
    }
}

// MARK: - Feature Action

enum ClubDetailsAction: UIFeatureAction {
    case fetchData
    case loadMoreEvents
    case backTapped
    case editTapped
    case userTapped(String)
    case eventTapped(String)
    case joinClubTapped
    case seeAllMembersTapped
    case assignRole(userId: String, role: AppPresentationModel.UserActivityRole)
    case exitTapped
    case requestVerificationTapped
    case createEventTapped
}

// MARK: - PreferenceKey

struct TabHeightPreferenceKey: PreferenceKey {
    static var defaultValue: [ClubDetailsViewState.SegmentTypes: CGFloat] = [:]
    
    static func reduce(value: inout [ClubDetailsViewState.SegmentTypes: CGFloat], nextValue: () -> [ClubDetailsViewState.SegmentTypes: CGFloat]) {
        value.merge(nextValue()) { _, new in new }
    }
}
