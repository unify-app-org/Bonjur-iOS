//
//  FacultyBrowseModel.swift
//  CommunitiesImpl
//
//  Created by aplle on 3/21/26.
//

import AppFoundation
import Communities
import SwiftUI


// MARK: - FacultyBrowse input

struct FacultyBrowseInputData {
    let title: String
    let sectionTitle: String
    let faculties: [CommunitiesMemberModuleModel.FacultyRowModel]
    let onFacultyTapped: (CommunitiesMemberModuleModel.FacultyRowModel) -> Void
}
// MARK: - Side effects

enum FacultyBrowseSideEffect: UISideEffect {
    case loading(Bool)
}

// MARK: - Feature Definition

typealias FacultyBrowseFeature = UIFeatureDefinition<
    FacultyBrowseViewState,
    FacultyBrowseAction,
    FacultyBrowseSideEffect
>

// MARK: - View State
final class FacultyBrowseViewState: UIFeatureState {
    @Published var title: String = ""
    @Published var sectionTitle: String = ""
    @Published var faculties: [CommunitiesMemberModuleModel.FacultyRowModel] = []
}


// MARK: - Feature Action
enum FacultyBrowseAction: UIFeatureAction {
    case onAppear
    case facultyTapped(CommunitiesMemberModuleModel.FacultyRowModel)
}
