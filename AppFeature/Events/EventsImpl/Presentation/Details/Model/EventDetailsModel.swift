//
//  EventDetailsModel.swift
//  EventsImpl
//
//  Created by Huseyn Hasanov on 01.02.26.
//

import AppFoundation
import SwiftUICore

// MARK: - EventDetails input

struct EventDetailsInputData {
    let eventId: String
}

// MARK: - Side effects

enum EventDetailsSideEffect: UISideEffect {
    case loading(Bool)
}

// MARK: - Feature Definition

typealias EventDetailsFeature = UIFeatureDefinition<
    EventDetailsViewState,
    EventDetailsAction,
    EventDetailsSideEffect
>

// MARK: - View State

final class EventDetailsViewState: UIFeatureState {
    
    @Published var uiModel: EventsDetailsModel.UIModel?
    @Published var selectedSegment: SegmentTypes = .about
    @Published var isFileUploadReachedMaxLimit = false
    
    enum SegmentTypes: String, CaseIterable, Identifiable {
        case about = "About"
        case members = "Members"
        
        var id: Self { self }
    }
}

// MARK: - Feature Action

enum EventDetailsAction: UIFeatureAction {
    case fetchData
    case backTapped
}

// MARK: - PreferenceKey

struct TabHeightPreferenceKey: PreferenceKey {
    static var defaultValue: [EventDetailsViewState.SegmentTypes: CGFloat] = [:]
    
    static func reduce(value: inout [EventDetailsViewState.SegmentTypes: CGFloat], nextValue: () -> [EventDetailsViewState.SegmentTypes: CGFloat]) {
        value.merge(nextValue()) { _, new in new }
    }
}
