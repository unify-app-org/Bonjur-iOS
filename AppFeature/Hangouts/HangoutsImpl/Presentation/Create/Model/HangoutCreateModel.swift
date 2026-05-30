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
    @Published var visibility: AppPresentationModel.AccessType = .public
    @Published var name: String = ""
    @Published var ownerContact: String = ""
    @Published var clubName: String = ""
    @Published var clubOwnerContact: String = ""
    @Published var capacity: String = ""
    @Published var links: [AppLinkItem] = []
    @Published var rules: String = ""
    @Published var location: String = ""
    @Published var about: String = ""
    @Published var hangoutDate: Date = Date()
    @Published var endDate: Date = Date()
    @Published var showCategoryPicker: Bool = false
    @Published var categorySections: [SelectCategoryView.Section] = []
    @Published var disabledName: Bool = false
    
    var selectedCategories: [CategoriesChipsView.Model] {
        categorySections
            .flatMap(\.categories)
            .filter(\.selected)
    }
    
    var isValid: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !ownerContact.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !clubName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !clubOwnerContact.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !selectedCategories.isEmpty &&
        !rules.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !location.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !about.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
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
