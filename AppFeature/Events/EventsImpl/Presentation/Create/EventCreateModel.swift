//
//  EventCreateModel.swift
//  EventsImpl
//
//  Created by Huseyn Hasanov on 21.02.26.
//

import AppFoundation
import AppNetwork
import AppUIKit
import Foundation

// MARK: - EventCreate input

struct EventCreateInputData {
    let eventId: String?
    let prefillData: EventsCreate.PrefillData?

    init(
        eventId: String? = nil,
        prefillData: EventsCreate.PrefillData? = nil
    ) {
        self.eventId = eventId
        self.prefillData = prefillData
    }
}

// MARK: - Side effects

enum EventCreateSideEffect: UISideEffect {
    case loading(Bool)
    case error(APIError?)
}

// MARK: - Eligible-clubs load phase

/// Drives what the create screen renders. `forEvents` only returns clubs the
/// user may post to (organizer role AND verified club), so an empty result and
/// a network failure must be told apart — they look identical otherwise.
enum EventCreateClubsPhase {
    case loading
    case loaded   // has eligible clubs → show the form
    case empty    // no president/VP/organizer role in any verified club
    case failed   // fetch error → retry
}

// MARK: - Feature Definition

typealias EventCreateFeature = UIFeatureDefinition<
    EventCreateViewState,
    EventCreateAction,
    EventCreateSideEffect
>

// MARK: - View State

final class EventCreateViewState: UIFeatureState {
    @Published var schema: [EventsCreate.FieldSchema] = EventsCreate.schema
    @Published var isEdit: Bool = false
    @Published var values: [EventsCreate.FieldID: EventsCreate.FieldValue] = [
        .visibility: .radio(.public),
        .eventDate: .date(Date()),
        .reminder: .reminders([.none])
    ]

    @Published var clubs: [EventsCreate.SelectableClub] = []
    @Published var clubsPhase: EventCreateClubsPhase = .loading
    @Published var showClubPicker: Bool = false

    @Published var categorySections: [SelectCategoryView.Section] = []
    @Published var showCategoryPicker: Bool = false

    @Published var selectedClub: EventsCreate.SelectableClub?

    var selectedCategories: [CategoriesChipsView.Model] {
        categorySections
            .flatMap(\.categories)
            .filter(\.selected)
    }

    var isValid: Bool {
        values.isValid(for: schema)
            && !values.text(.eventName).trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            && selectedClub != nil
    }

    var topTitle: String {
        isEdit ? "events_edit_title".localized : "events_create_title".localized
    }
}

// MARK: - Feature Action

enum EventCreateAction: UIFeatureAction {
    case fetchData
    case retryTapped
    case createClubTapped
    case browseClubsTapped
    case backTapped
    case continueTapped
    case selectClubTapped
    case dismissClubPicker
    case selectClub(EventsCreate.SelectableClub)
    case addCategoryTapped
    case removeCategory(Int)
    case dismissCategoryPicker
    case categoryPickerDone
}
