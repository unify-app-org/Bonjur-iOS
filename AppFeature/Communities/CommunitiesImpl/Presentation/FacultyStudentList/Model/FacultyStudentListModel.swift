//
//  FacultyStudentListModel.swift
//  CommunitiesImpl
//
//  Created by aplle on 3/22/26.
//

import AppFoundation
import Combine
import Communities

// MARK: - FacultyStudentList input

struct FacultyStudentListInputData {
    let title: String
    let sections: [CommunitiesMemberModuleModel.MemberListSection]
    let onMemberTapped: (CommunitiesMemberModuleModel.MemberCellModel) -> Void

   
}

// MARK: - Side effects

enum FacultyStudentListSideEffect: UISideEffect {
    case loading(Bool)
}

// MARK: - Feature Definition

typealias FacultyStudentListFeature = UIFeatureDefinition<
    FacultyStudentListViewState,
    FacultyStudentListAction,
    FacultyStudentListSideEffect
>

// MARK: - Content State

enum FacultyStudentListContentState {
    case list
    case empty
    case noSearchResults
}

// MARK: - View State

final class FacultyStudentListViewState: UIFeatureState {
    @Published var title: String = ""
    @Published var sections: [MemberListSectionViewData] = []
    @Published var filteredSections: [MemberListSectionViewData] = []
    @Published var searchText: String = ""
    @Published var contentState: FacultyStudentListContentState = .empty
}

// MARK: - Feature Action

enum FacultyStudentListAction: UIFeatureAction {
    case onAppear
    case searchChanged(String)
    case memberTapped(MemberCellViewData)
}
