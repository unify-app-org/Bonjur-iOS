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

// MARK: - ClubDetails input

struct ClubDetailsInputData {
    let clubId: Int
}

// MARK: - Side effects

enum ClubDetailsSideEffect: UISideEffect {
    case loading(Bool)
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
    @Published var clubMembersInput: CommunitiesMemberModuleModel.ClubMembersInput?
    @Published var selectedSegment: SegmentTypes = .about
    
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
    case backTapped
}

// MARK: - PreferenceKey

struct TabHeightPreferenceKey: PreferenceKey {
    static var defaultValue: [ClubDetailsViewState.SegmentTypes: CGFloat] = [:]
    
    static func reduce(value: inout [ClubDetailsViewState.SegmentTypes: CGFloat], nextValue: () -> [ClubDetailsViewState.SegmentTypes: CGFloat]) {
        value.merge(nextValue()) { _, new in new }
    }
}
