//
//  CommunityDetailModel.swift
//  CommunitiesImpl
//
//  Created by Huseyn Hasanov on 03.02.26.
//

import AppFoundation
import SwiftUI

// MARK: - CommunityDetail input

struct CommunityDetailInputData {
    let communityId: Int
}

// MARK: - Side effects

enum CommunityDetailSideEffect: UISideEffect {
    case loading(Bool)
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
    
    enum SegmentTypes: String, CaseIterable, Identifiable {
        case about = "About"
        case clubs = "Clubs"
        
        var id: Self { self }
    }
}

// MARK: - Feature Action

enum CommunityDetailAction: UIFeatureAction {
    case fetchData
    case backTapped
    case clubItemTapped(Int)
}

// MARK: - PreferenceKey

struct TabHeightPreferenceKey: PreferenceKey {
    static var defaultValue: [CommunityDetailViewState.SegmentTypes: CGFloat] = [:]
    
    static func reduce(value: inout [CommunityDetailViewState.SegmentTypes: CGFloat], nextValue: () -> [CommunityDetailViewState.SegmentTypes: CGFloat]) {
        value.merge(nextValue()) { _, new in new }
    }
}
