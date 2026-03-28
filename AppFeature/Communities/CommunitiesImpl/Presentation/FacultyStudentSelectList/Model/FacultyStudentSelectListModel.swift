//
//  FacultyStudentSelectListModel.swift
//  CommunitiesImpl
//
//  Created by aplle on 3/22/26.
//

import AppFoundation
import Communities
import SwiftUI
// MARK: - FacultyStudentSelectList input

struct FacultyStudentSelectListInputData {
    let title: String
    let sections: [CommunitiesMemberModuleModel.MemberListSection]
    let capacityLimit: Int?
    let onSelectionConfirmed: ([CommunitiesMemberModuleModel.MemberCellModel]) -> Void
}

// MARK: - Side effects

enum FacultyStudentSelectListSideEffect: UISideEffect {
    case loading(Bool)
    case capacityLimitReached(overflowCount: Int)
}

// MARK: - Feature Definition

typealias FacultyStudentSelectListFeature = UIFeatureDefinition<
    FacultyStudentSelectListViewState,
    FacultyStudentSelectListAction,
    FacultyStudentSelectListSideEffect
>

// MARK: - View State

final class FacultyStudentSelectListViewState: UIFeatureState {
    @Published var title: String = ""
    @Published var sections: [MemberListSectionViewData] = []
    @Published var filteredSections: [MemberListSectionViewData] = []
    @Published var searchText: String = ""
    @Published var selectedIDs: Set<String> = []
    @Published var isAllSelected: Bool = false
}

// MARK: - Feature Action

enum FacultyStudentSelectListAction: UIFeatureAction {
    case onAppear
    case searchChanged(String)
    case selectAllTapped
    case memberTapped(MemberCellViewData)
    case groupTapped(MemberListSectionViewData)
    case continueTapped
}
