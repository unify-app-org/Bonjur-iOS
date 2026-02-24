//
//  HangoutDetailsModel.swift
//  HangoutsImpl
//
//  Created by Huseyn Hasanov on 02.02.26.
//

import AppFoundation
import SwiftUI

// MARK: - HangoutDetails input

struct HangoutDetailsInputData {
    let hangoutId: String
}

// MARK: - Side effects

enum HangoutDetailsSideEffect: UISideEffect {
    case loading(Bool)
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
    @Published var selectedSegment: SegmentTypes = .about
    @Published var isFileUploadReachedMaxLimit = false
    
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
}


// MARK: - PreferenceKey

struct TabHeightPreferenceKey: PreferenceKey {
    static var defaultValue: [HangoutDetailsViewState.SegmentTypes: CGFloat] = [:]
    
    static func reduce(value: inout [HangoutDetailsViewState.SegmentTypes: CGFloat], nextValue: () -> [HangoutDetailsViewState.SegmentTypes: CGFloat]) {
        value.merge(nextValue()) { _, new in new }
    }
}
