//
//  EventCreateModel.swift
//  EventsImpl
//
//  Created by Huseyn Hasanov on 21.02.26.
//

import AppFoundation

// MARK: - EventCreate input

struct EventCreateInputData {
}

// MARK: - Side effects

enum EventCreateSideEffect: UISideEffect {
    case loading(Bool)
}

// MARK: - Feature Definition

typealias EventCreateFeature = UIFeatureDefinition<
    EventCreateViewState,
    EventCreateAction,
    EventCreateSideEffect
>

// MARK: - View State

final class EventCreateViewState: UIFeatureState {
}

// MARK: - Feature Action

enum EventCreateAction: UIFeatureAction {
}
