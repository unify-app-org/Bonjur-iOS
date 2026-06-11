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
        isEdit ? "Edit event" : "Create new event"
    }
}

// MARK: - Feature Action

enum EventCreateAction: UIFeatureAction {
    case fetchData
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
