//
//  ClubCreateModel.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 21.02.26.
//

import AppFoundation
import AppUIKit
import Combine
import Foundation

// MARK: - ClubCreate input

struct ClubCreateInputData {
}

// MARK: - Side effects

enum ClubCreateSideEffect: UISideEffect {
    case loading(Bool)
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
    @Published var values: [ClubsCreate.FieldID: ClubsCreate.FieldValue] = [
        .cover : .cover(.primary),
        .visibility: .radio(.public)
    ]
    
    var isValid: Bool {
        values.isValid(for: clubsCreateSchema)
    }
}

// MARK: - Feature Action

enum ClubCreateAction: UIFeatureAction {
    case fetchData
    case backTapped
}
