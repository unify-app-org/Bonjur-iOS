//
//  FacultyStudentListModel.swift
//  CommunitiesImpl
//
//  Created by aplle on 3/22/26.
//

import AppFoundation
import Communities
import Combine
// MARK: - FacultyStudentList input


struct FacultyStudentListInputData {
    let title: String
    let facultyOptions: [String]
    let sections: [CommunitiesMemberModuleModel.MemberListSection]
    let onMemberTapped: (CommunitiesMemberModuleModel.MemberCellModel) -> Void
}

struct FacultyStudentListSelectInputData {
    let title: String
    let facultyOptions: [String]
    let sections: [CommunitiesMemberModuleModel.MemberListSection]
    let capacityLimit: Int?
    let onSelectionConfirmed: ([CommunitiesMemberModuleModel.MemberCellModel]) -> Void
    let onSkip: () -> Void
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

// MARK: - View State

final class FacultyStudentListViewState: UIFeatureState {
    @Published var title: String = ""
      @Published var facultyOptions: [String] = []
      @Published var selectedFaculty: String = ""
      @Published var sections: [MemberListSectionViewData] = []
      @Published var searchText: String = ""
      @Published var isSelectionMode: Bool = false
}

// MARK: - Feature Action

enum FacultyStudentListAction: UIFeatureAction {
    case onAppear
       case searchChanged(String)
       case facultyChanged(String)
       case memberTapped(MemberCellViewData)
       case accessoryTapped(MemberCellViewData)
       case groupTapped(MemberListSectionViewData)
       case continueTapped
       case skipTapped
}
