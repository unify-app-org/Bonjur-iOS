//
//  ClubCreateModel.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 21.02.26.
//

import AppFoundation
import AppUIKit
import AppNetwork
import Combine
import Foundation

// MARK: - ClubCreate input

struct ClubCreateInputData {
    let id: Int?
    let prefillData: ClubsCreate.PrefillData?
    
    init(
        id: Int? = nil,
        prefillData: ClubsCreate.PrefillData? = nil
    ) {
        self.id = id
        self.prefillData = prefillData
    }
}

// MARK: - Side effects

enum ClubCreateSideEffect: UISideEffect {
    case loading(Bool)
    case error(APIError?)
}

// MARK: - Feature Definition

typealias ClubCreateFeature = UIFeatureDefinition<
    ClubCreateViewState,
    ClubCreateAction,
    ClubCreateSideEffect
>

// MARK: - View State

final class ClubCreateViewState: UIFeatureState {
    @Published var clubsCreateSchema: [ClubsCreate.FieldSchema] = []
    @Published var selectedLogo: Data?
    @Published var backgroundPhoto: Data?
    @Published var existingLogoURL: URL?
    @Published var existingCoverURL: URL?
    @Published var showCategoryPicker: Bool = false
    /// Post-create prompt: a brand-new club is unverified, and verification is
    /// the hard gate to creating events in it. Shown only on the create path.
    @Published var showVerifyPrompt: Bool = false
    /// Id of the just-created club, used to fire the verify request from the prompt.
    @Published var createdClubId: Int?
    @Published var categorySections: [SelectCategoryView.Section] = []
    @Published var disabledFieldIDs: Set<ClubsCreate.FieldID> = []
    @Published var values: [ClubsCreate.FieldID: ClubsCreate.FieldValue] = [
        .cover : .cover(.primary),
        .visibility: .radio(.public)
    ]
    
    var selectedCategories: [CategoriesChipsView.Model] {
        categorySections
            .flatMap(\.categories)
            .filter(\.selected)
    }
    
    /// A profile photo is mandatory: require a freshly-picked logo on create, or
    /// an existing one on edit. Cover stays optional (a colour is used as fallback).
    var hasProfilePhoto: Bool {
        selectedLogo != nil || existingLogoURL != nil
    }

    var isValid: Bool {
        hasProfilePhoto && values.isValid(for: clubsCreateSchema)
    }
}

// MARK: - Feature Action

enum ClubCreateAction: UIFeatureAction {
    case fetchData
    case backTapped
    case addCategoryTapped
    case removeCategory(Int)
    case dismissCategoryPicker
    case categoryPickerDone
    case continueTapped
    case requestVerificationTapped
    case dismissVerifyPrompt
}
