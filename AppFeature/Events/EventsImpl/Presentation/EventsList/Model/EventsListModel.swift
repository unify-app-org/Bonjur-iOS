//
//  EventsListModel.swift
//  EventsImpl
//
//  Created by Huseyn Hasanov on 22.01.26.
//

import AppFoundation
import Combine
import AppNetwork
import AppUIKit

// MARK: - EventsList input

struct EventsListInputData {
}

// MARK: - Side effects

enum EventsListSideEffect: UISideEffect {
    case loading(Bool)
    case error(APIError)
}

// MARK: - Feature Definition

typealias EventsListFeature = UIFeatureDefinition<
    EventsListViewState,
    EventsListAction,
    EventsListSideEffect
>

// MARK: - View State

final class EventsListViewState: UIFeatureState {
    @Published var uiModel: UIModel = .init(events: [])
    
    struct UIModel {
        var events: [EventsCardView.Model]
        var filters: [FilterView.Model] = []
    }
}

// MARK: - Feature Action

enum EventsListAction: UIFeatureAction {
    case fetchData
    case fetchCategories
    case filtersSelected([FilterView.Items])
    case eventItemTapped(id: String)
    case joinEvent(id: String)
}
