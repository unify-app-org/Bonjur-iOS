//
//  FacultyStudentListViewModel.swift
//  CommunitiesImpl
//
//  Created by aplle on 3/22/26.
//

import AppFoundation
import Communities

final class FacultyStudentListViewModel: UIFeatureViewModel<FacultyStudentListFeature> {
    
    struct Dependencies {
    }
    
    private let router: FacultyStudentListRouterProtocol
    private let inputData: FacultyStudentListInputData
    private let dependencies: FacultyStudentListViewModel.Dependencies
    private var sourceSections: [CommunitiesMemberModuleModel.MemberListSection] = []
    
    init(
        state: FacultyStudentListFeature.State,
        router: FacultyStudentListRouterProtocol,
        inputData: FacultyStudentListInputData,
        dependencies: FacultyStudentListViewModel.Dependencies
    ) {
        self.router = router
        self.inputData = inputData
        self.dependencies = dependencies
        super.init(initialState: state)
    }
    
    override func handle(action: FacultyStudentListFeature.Action) {
        switch action {
        case .onAppear:
            fetchData()
        case .searchChanged(let searchText):
            state.searchText = searchText
            applySearch()
        case .memberTapped(let row):
            inputData.onMemberTapped(row.member)
        }
    }

    private func fetchData() {
        let input = inputData
        state.title = input.title
        sourceSections = input.sections
        state.sections = input.sections.enumerated().map { index, section in
            .browse(id: "section-\(index)", section: section)
        }
        state.filteredSections = state.sections
    }

    private func applySearch() {
        let query = state.searchText
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()

        guard !query.isEmpty else {
            state.filteredSections = state.sections
            return
        }

        state.filteredSections = sourceSections.enumerated().compactMap { index, section in
            let filteredMembers = section.members.filter { member in
                member.name.lowercased().contains(query)
                || member.subtitle.lowercased().contains(query)
            }

            guard !filteredMembers.isEmpty else {
                return nil
            }

            return .browse(
                id: "section-\(index)",
                section: .init(
                    title: section.title,
                    memberCount: filteredMembers.count,
                    members: filteredMembers
                )
            )
        }
    }
}
