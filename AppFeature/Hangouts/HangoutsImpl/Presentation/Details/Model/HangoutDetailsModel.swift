//
//  HangoutDetailsModel.swift
//  HangoutsImpl
//
//  Created by Huseyn Hasanov on 02.02.26.
//

import AppFoundation
import Communities
import SwiftUI
import AppNetwork

// MARK: - HangoutDetails input

struct HangoutDetailsInputData {
    let hangoutId: String
}

// MARK: - Side effects

enum HangoutDetailsSideEffect: UISideEffect {
    case loading(Bool)
    case error(APIError)
}

// MARK: - Feature Definition

typealias HangoutDetailsFeature = UIFeatureDefinition<
    HangoutDetailsViewState,
    HangoutDetailsAction,
    HangoutDetailsSideEffect
>

// MARK: - View State

final class HangoutDetailsViewState: UIFeatureState {
    @Published var uiModel: HangoutDetails.UIModel?
    @Published var membersData: CommunitiesMemberModuleModel.GroupedMembersData?
    @Published var selectedSegment: SegmentTypes = .about
    @Published var isFileUploadReachedMaxLimit = false
    
    var isEditable: Bool {
        uiModel?.userActivityType == .visePresident || uiModel?.userActivityType == .president
    }
    var canCreateEvent: Bool {
        uiModel?.userActivityType != .member && uiModel?.userActivityType != .notJoined
    }
    var hasJoined: Bool {
        uiModel?.userActivityType != .notJoined
    }
    var isPrivate: Bool {
        uiModel?.accessType == .private
    }
    
    enum SegmentTypes: String, CaseIterable, Identifiable {
        case about = "About"
        case members = "Members"
        
        var id: Self { self }
    }
}

// MARK: - Feature Action

enum HangoutDetailsAction: UIFeatureAction {
    case fetchData
    case backTapped
    case editTapped
}


// MARK: - PreferenceKey

struct TabHeightPreferenceKey: PreferenceKey {
    static var defaultValue: [HangoutDetailsViewState.SegmentTypes: CGFloat] = [:]
    
    static func reduce(value: inout [HangoutDetailsViewState.SegmentTypes: CGFloat], nextValue: () -> [HangoutDetailsViewState.SegmentTypes: CGFloat]) {
        value.merge(nextValue()) { _, new in new }
    }
}
