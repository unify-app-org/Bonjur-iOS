//
//  FacultyStudentSelectListViewModel.swift
//  CommunitiesImpl
//
//  Created by aplle on 3/22/26.
//

import AppFoundation
import Communities


final class FacultyStudentSelectListViewModel: UIFeatureViewModel<FacultyStudentSelectListFeature> {
    
    struct Dependencies {
    }
    
    private let router: FacultyStudentSelectListRouterProtocol
    private let inputData: FacultyStudentSelectListInputData
    private let dependencies: FacultyStudentSelectListViewModel.Dependencies
    private var sourceSections: [CommunitiesMemberModuleModel.MemberListSection] = []
    
    init(
        state: FacultyStudentSelectListFeature.State,
        router: FacultyStudentSelectListRouterProtocol,
        inputData: FacultyStudentSelectListInputData,
        dependencies: FacultyStudentSelectListViewModel.Dependencies
    ) {
        self.router = router
        self.inputData = inputData
        self.dependencies = dependencies
        super.init(initialState: state)
    }
    
    override func handle(action: FacultyStudentSelectListAction) {
            switch action {
            case .onAppear:
                fetchData()

            case .searchChanged(let text):
                state.searchText = text
                rebuildSections()

            case .selectAllTapped:
                toggleSelectAll()

            case .memberTapped(let row):
                toggleSelection(for: row.id)

            case .groupTapped(let section):
                toggleGroup(section)

            case .continueTapped:
                continueSelection()
            }
        }

        private func fetchData() {
            state.title = inputData.title
            sourceSections = inputData.sections
            rebuildSections()
        }

        private func rebuildSections() {
            let query = state.searchText
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .lowercased()

            let visibleSections = sourceSections.enumerated().compactMap { index, section -> MemberListSectionViewData? in
                let members = query.isEmpty
                    ? section.members
                    : section.members.filter {
                        $0.name.lowercased().contains(query)
                        || $0.subtitle.lowercased().contains(query)
                    }

                guard !members.isEmpty else { return nil }

                let memberIDs = Set(members.map(\.id))
                let isGroupSelected = memberIDs.isSubset(of: state.selectedIDs)

                return .init(
                    id: "section-\(index)",
                    title: section.title,
                    memberCountText: nil,
                    rows: members.map {
                        .selectable(from: $0, isSelected: state.selectedIDs.contains($0.id))
                    },
                    showsSelectGroup: true,
                    isGroupSelected: isGroupSelected
                )
            }

            state.sections = visibleSections
            state.filteredSections = visibleSections

            let allVisibleIDs = Set(
                visibleSections
                    .flatMap(\.rows)
                    .map(\.id)
            )
            state.isAllSelected = !allVisibleIDs.isEmpty && allVisibleIDs.isSubset(of: state.selectedIDs)
        }

        private func toggleSelection(for id: String) {
            if state.selectedIDs.contains(id) {
                state.selectedIDs.remove(id)
            } else {
                state.selectedIDs.insert(id)
            }
            rebuildSections()
        }

        private func toggleGroup(_ section: MemberListSectionViewData) {
            let ids = Set(section.rows.map(\.id))
            let allSelected = ids.isSubset(of: state.selectedIDs)

            if allSelected {
                state.selectedIDs.subtract(ids)
            } else {
                state.selectedIDs.formUnion(ids)
            }
            rebuildSections()
        }

        private func toggleSelectAll() {
            let visibleIDs = Set(
                state.filteredSections
                    .flatMap(\.rows)
                    .map(\.id)
            )

            if visibleIDs.isSubset(of: state.selectedIDs) {
                state.selectedIDs.subtract(visibleIDs)
            } else {
                state.selectedIDs.formUnion(visibleIDs)
            }
            rebuildSections()
        }

        private func continueSelection() {
            let selectedMembers = sourceSections
                .flatMap(\.members)
                .filter { state.selectedIDs.contains($0.id) }

            if let limit = inputData.capacityLimit, selectedMembers.count > limit {
                postEffect(.capacityLimitReached(overflowCount: selectedMembers.count - limit))
                return
            }

            inputData.onSelectionConfirmed(selectedMembers)
        }
}
