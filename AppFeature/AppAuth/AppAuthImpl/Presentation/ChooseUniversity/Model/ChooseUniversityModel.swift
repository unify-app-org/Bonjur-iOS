//
//  ChooseUniversityModel.swift
//  AppAuthImpl
//
//  Created by Huseyn Hasanov on 26.12.25.
//

import AppFoundation
import AppUIKit
import Combine

// MARK: - ChooseUniversity input

struct ChooseUniversityInputData {
}

// MARK: - Side effects

enum ChooseUniversitySideEffect: UISideEffect {
    case loading(Bool)
}

// MARK: - Feature Definition

typealias ChooseUniversityFeature = UIFeatureDefinition<
    ChooseUniversityViewState,
    ChooseUniversityAction,
    ChooseUniversitySideEffect
>

// MARK: - View State

final class ChooseUniversityViewState: UIFeatureState {
    @Published var uiModel: [SelectableListItemView.Model] = []
    var disabled: Bool {
         uiModel.first(where: { $0.selected }) == nil
     }
}

// MARK: - Feature Action

enum ChooseUniversityAction: UIFeatureAction {
    case fetchData
    case selectedCell(Int)
    case nextTapped
}
