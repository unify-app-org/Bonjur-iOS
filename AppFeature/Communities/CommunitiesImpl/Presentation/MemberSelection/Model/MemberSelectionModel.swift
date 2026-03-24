//
//  MemberSelectionModel.swift
//  CommunitiesImpl
//
//  Created by aplle on 3/23/26.
//

import AppFoundation
import Communities
import SwiftUI

// MARK: - MemberSelection input

struct MemberSelectionInputData {
    let title: String
    let sectionTitle: String
    let sections: [CommunitiesMemberModuleModel.MemberListSection]
    let capacityLimit: Int?
    let onNext: ([CommunitiesMemberModuleModel.MemberCellModel]) -> Void
    let onSkip: () -> Void
}

// MARK: - Side effects

enum MemberSelectionSideEffect: UISideEffect {
    case loading(Bool)
    case capacityLimitReached(overflowCount: Int)
}

// MARK: - Feature Definition

typealias MemberSelectionFeature = UIFeatureDefinition<
    MemberSelectionViewState,
    MemberSelectionAction,
    MemberSelectionSideEffect
>

// MARK: - View State

final class MemberSelectionViewState: UIFeatureState {
    @Published var title: String = ""
    @Published var sectionTitle: String = ""
    @Published var rows: [FacultyRowViewData] = []
    @Published var selectedSectionIDs: Set<String> = []
}

// MARK: - Feature Action

enum MemberSelectionAction: UIFeatureAction {
    case onAppear
    case rowTapped(FacultyRowViewData)
    case nextTapped
    case skipTapped
}
