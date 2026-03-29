//
//  FacultySelectionModel.swift
//  CommunitiesImpl
//
//  Created by aplle on 3/23/26.
//

import AppFoundation
import Communities
import SwiftUI

// MARK: - FacultySelection input

struct FacultySelectionInputData {
    let title: String
    let sectionTitle: String
    let mode: FacultySelectionMode
    let onSkip: () -> Void
}

enum FacultySelectionMode {
    case preloadedMembers(
        faculties: [CommunitiesMemberModuleModel.FacultyRowModel],
        capacityLimit: Int?,
        onNext: ([CommunitiesMemberModuleModel.MemberCellModel]) -> Void
    )
    case callback(
        faculties: [CommunitiesMemberModuleModel.FacultyRowModel],
        onNext: ([CommunitiesMemberModuleModel.FacultyRowModel]) -> Void
    )
}

// MARK: - Side effects

enum FacultySelectionSideEffect: UISideEffect {
    case loading(Bool)
    case capacityLimitReached(overflowCount: Int)
}

// MARK: - Feature Definition

typealias FacultySelectionFeature = UIFeatureDefinition<
    FacultySelectionViewState,
    FacultySelectionAction,
    FacultySelectionSideEffect
>

// MARK: - View State

final class FacultySelectionViewState: UIFeatureState {
    @Published var title: String = ""
    @Published var sectionTitle: String = ""
    @Published var rows: [FacultyRowViewData] = []
    @Published var selectedSectionIDs: Set<String> = []
}

// MARK: - Feature Action

enum FacultySelectionAction: UIFeatureAction {
    case onAppear
    case rowTapped(FacultyRowViewData)
    case accessoryTapped(FacultyRowViewData)
    case nextTapped
    case skipTapped
}
