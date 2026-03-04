//
//  StudentCardModel.swift
//  ProfileImpl
//
//  Created by aplle on 3/4/26.
//

import AppFoundation
import AppUIKit

// MARK: - StudentCard input

struct StudentCardInputData {
    let userCardModel: UserCardModel
    let onSave: @MainActor (AppUIEntities.BackgroundType) -> Void
}

// MARK: - Side effects

enum StudentCardSideEffect: UISideEffect {
    case loading(Bool)
}

// MARK: - Feature Definition

typealias StudentCardFeature = UIFeatureDefinition<
    StudentCardViewState,
    StudentCardAction,
    StudentCardSideEffect
>

// MARK: - View State

final class StudentCardViewState: UIFeatureState {
}

// MARK: - Feature Action

enum StudentCardAction: UIFeatureAction {
}
