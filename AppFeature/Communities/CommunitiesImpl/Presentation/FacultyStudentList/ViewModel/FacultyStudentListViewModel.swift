//
//  FacultyStudentListViewModel.swift
//  CommunitiesImpl
//
//  Created by aplle on 3/22/26.
//

import AppFoundation

final class FacultyStudentListViewModel: UIFeatureViewModel<FacultyStudentListFeature> {
    
    struct Dependencies {
    }
    
    private let router: FacultyStudentListRouterProtocol
    private let inputData: FacultyStudentListInputData
    private let selectInputData: FacultyStudentListSelectInputData?
    private let dependencies: FacultyStudentListViewModel.Dependencies
    
    init(
        state: FacultyStudentListFeature.State,
        router: FacultyStudentListRouterProtocol,
        inputData: FacultyStudentListInputData,
        selectInputData: FacultyStudentListSelectInputData?,
        dependencies: FacultyStudentListViewModel.Dependencies
    ) {
        self.router = router
        self.inputData = inputData
        self.dependencies = dependencies
        self.selectInputData = selectInputData
        super.init(initialState: state)
    }
    
    override func handle(action: FacultyStudentListFeature.Action) {
            switch action {
            case .onAppear:
                fetchData()
            case .memberTapped(let row):
                inputData.onMemberTapped(row.member)
            default:
                break
            }
        }

        private func fetchData() {
             let input = inputData
            state.title = input.title
            state.facultyOptions = input.facultyOptions
            state.selectedFaculty = input.facultyOptions.first ?? ""
            state.isSelectionMode = false
            state.sections = input.sections.enumerated().map { index, section in
                .browse(id: "section-\(index)", section: section)
            }
        }
}
