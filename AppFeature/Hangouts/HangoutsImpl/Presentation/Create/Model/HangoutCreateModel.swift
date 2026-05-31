//
//  HangoutCreateModel.swift
//  AppFeature
//
//  Created by Codex on 30.05.26.
//

import AppFoundation
import AppUIKit
import AppNetwork
import Combine
import Foundation
import AppPresentationModel

// MARK: - HangoutCreate input

struct HangoutCreateInputData {
    let id: String?
    let prefillData: HangoutsCreate.PrefillData?

    init(
        id: String? = nil,
        prefillData: HangoutsCreate.PrefillData? = nil
    ) {
        self.id = id
        self.prefillData = prefillData
    }
}

// MARK: - Side effects

enum HangoutCreateSideEffect: UISideEffect {
    case loading(Bool)
    case error(APIError?)
}

// MARK: - Feature Definition

typealias HangoutCreateFeature = UIFeatureDefinition<
    HangoutCreateViewState,
    HangoutCreateAction,
    HangoutCreateSideEffect
>

// MARK: - View State

final class HangoutCreateViewState: UIFeatureState {
    @Published var hangoutsCreateSchema: [HangoutsCreate.FieldSchema] = []
    @Published var showCategoryPicker: Bool = false
    @Published var categorySections: [SelectCategoryView.Section] = []
    @Published var disabledFieldIDs: Set<HangoutsCreate.FieldID> = []
    @Published var isEdit: Bool = false
    @Published var values: [HangoutsCreate.FieldID: HangoutsCreate.FieldValue] = [
        .visibility: .radio(.public),
        .hangoutDate: .date(Date())
    ]

    var selectedCategories: [CategoriesChipsView.Model] {
        categorySections
            .flatMap(\.categories)
            .filter(\.selected)
    }

    var isValid: Bool {
        values.isValid(for: hangoutsCreateSchema)
    }

    var topTitle: String {
        isEdit ? "Edit hangout" : "Create new hangouts"
    }
}

// MARK: - Feature Action

enum HangoutCreateAction: UIFeatureAction {
    case fetchData
    case backTapped
    case addCategoryTapped
    case removeCategory(Int)
    case dismissCategoryPicker
    case categoryPickerDone
    case continueTapped
}
