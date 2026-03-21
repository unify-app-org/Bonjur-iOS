//
//  MemberBrowseModel.swift
//  CommunitiesImpl
//
//  Created by aplle on 3/21/26.
//

import AppFoundation
import Communities
import SwiftUI


// MARK: - MemberBrowse input

struct MemberBrowseInputData {
    let title: String
    let sectionTitle: String
    let faculties: [CommunitiesMemberModuleModel.FacultyRowModel]
    let onFacultyTapped: (CommunitiesMemberModuleModel.FacultyRowModel) -> Void
}
// MARK: - Side effects

enum MemberBrowseSideEffect: UISideEffect {
    case loading(Bool)
}

// MARK: - Feature Definition

typealias MemberBrowseFeature = UIFeatureDefinition<
    MemberBrowseViewState,
    MemberBrowseAction,
    MemberBrowseSideEffect
>

// MARK: - View State
final class MemberBrowseViewState: UIFeatureState {
    @Published var title: String = ""
    @Published var sectionTitle: String = ""
    @Published var faculties: [CommunitiesMemberModuleModel.FacultyRowModel] = []
}


// MARK: - Feature Action
enum MemberBrowseAction: UIFeatureAction {
    case onAppear
    case facultyTapped(CommunitiesMemberModuleModel.FacultyRowModel)
}
