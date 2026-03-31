//
//  FacultySelectionViewModel.swift
//  CommunitiesImpl
//
//  Created by aplle on 3/23/26.
//

import AppFoundation
import Communities

final class FacultySelectionViewModel: UIFeatureViewModel<FacultySelectionFeature> {
    struct Dependencies {
    }

    private struct SourceFaculty {
        let faculty: CommunitiesMemberModuleModel.FacultyRowModel

        var id: String { faculty.id }
        var title: String { faculty.title }
        var totalMembers: [CommunitiesMemberModuleModel.MemberCellModel] {
            faculty.sections.flatMap(\.members)
        }
    }

    private let router: FacultySelectionRouterProtocol
    private let inputData: FacultySelectionInputData
    private let dependencies: Dependencies
    private var sourceFaculties: [SourceFaculty] = []
    private var selectedMembersByFacultyID: [String: [CommunitiesMemberModuleModel.MemberCellModel]] = [:]

    init(
        state: FacultySelectionFeature.State,
        router: FacultySelectionRouterProtocol,
        inputData: FacultySelectionInputData,
        dependencies: Dependencies
    ) {
        self.router = router
        self.inputData = inputData
        self.dependencies = dependencies
        super.init(initialState: state)
    }

    override func handle(action: FacultySelectionFeature.Action) {
        switch action {
        case .onAppear:
            fetchData()

        case .rowTapped(let row):
            handleRowTap(row)

        case .accessoryTapped(let row):
            handleAccessoryTap(row)

        case .nextTapped:
            continueSelection()

        case .skipTapped:
            inputData.onSkip()
        }
    }

    private func fetchData() {
        state.title = inputData.title
        state.sectionTitle = inputData.sectionTitle

        switch inputData.mode {
        case .preloadedMembers(let faculties, _, _):
            sourceFaculties = faculties.map { SourceFaculty(faculty: $0) }

        case .callback(let faculties, _):
            sourceFaculties = faculties.map { SourceFaculty(faculty: $0) }
        }

        rebuildRows()
    }

    private func handleRowTap(_ row: FacultyRowViewData) {
        switch inputData.mode {
        case .preloadedMembers:
            openFacultySelection(rowID: row.id)

        case .callback:
            toggleSelection(for: row.id)
        }
    }

    private func handleAccessoryTap(_ row: FacultyRowViewData) {
        switch inputData.mode {
        case .preloadedMembers:
            toggleAllMembers(for: row.id)

        case .callback:
            toggleSelection(for: row.id)
        }
    }

    private func openFacultySelection(rowID: String) {
        guard let sourceFaculty = sourceFaculties.first(where: { $0.id == rowID }) else {
            return
        }

        let selectionInput = CommunitiesMemberModuleModel.FacultyStudentListSelectInput(
            title: sourceFaculty.faculty.studentListTitle ?? sourceFaculty.title,
            sections: sourceFaculty.faculty.sections,
            initiallySelectedMembers: selectedMembersByFacultyID[sourceFaculty.id] ?? []
        ) { [weak self] selectedMembers in
            self?.selectedMembersByFacultyID[sourceFaculty.id] = selectedMembers
            self?.rebuildRows()
        }
        
        Task {
            await router.navigate(to: .facultyStudentSelection(selectionInput))
        }
    }

    private func rebuildRows() {
        switch inputData.mode {
        case .preloadedMembers:
            let fullySelectedIDs = Set(
                sourceFaculties.compactMap { faculty in
                    let selectedMembers = selectedMembersByFacultyID[faculty.id] ?? []
                    let totalCount = faculty.totalMembers.count
                    let isFullySelected = totalCount > 0 && selectedMembers.count == totalCount
                    return isFullySelected ? faculty.id : nil
                }
            )
            state.selectedSectionIDs = fullySelectedIDs
            state.rows = sourceFaculties.map { faculty in
                let selectedMembers = selectedMembersByFacultyID[faculty.id] ?? []
                let totalCount = faculty.totalMembers.count
                let isFullySelected = totalCount > 0 && selectedMembers.count == totalCount
                let subtitle = selectedMembers.isEmpty || isFullySelected
                    ? nil
                    : "\(selectedMembers.count) user selected"
                
                return FacultyRowViewData(
                    id: faculty.id,
                    title: faculty.title,
                    subtitle: subtitle,
                    accessory: .selectable(isSelected: isFullySelected)
                )
            }

        case .callback:
            state.rows = sourceFaculties.map { faculty in
                FacultyRowViewData(
                    id: faculty.id,
                    title: faculty.title,
                    accessory: .selectable(
                        isSelected: state.selectedSectionIDs.contains(faculty.id)
                    )
                )
            }
        }
    }

    private func toggleSelection(for id: String) {
        if state.selectedSectionIDs.contains(id) {
            state.selectedSectionIDs.remove(id)
        } else {
            state.selectedSectionIDs.insert(id)
        }
        rebuildRows()
    }

    private func toggleAllMembers(for id: String) {
        guard let faculty = sourceFaculties.first(where: { $0.id == id }) else {
            return
        }

        let totalMembers = faculty.totalMembers
        let selectedMembers = selectedMembersByFacultyID[id] ?? []
        let isFullySelected = !totalMembers.isEmpty && selectedMembers.count == totalMembers.count

        if isFullySelected {
            selectedMembersByFacultyID[id] = []
        } else {
            selectedMembersByFacultyID[id] = totalMembers
        }

        rebuildRows()
    }

    private func continueSelection() {
        switch inputData.mode {
        case .preloadedMembers(_, let capacityLimit, let onNext):
            let selectedMembers = sourceFaculties
                .flatMap { selectedMembersByFacultyID[$0.id] ?? [] }

            if let capacityLimit, selectedMembers.count > capacityLimit {
                let overflowCount = selectedMembers.count - capacityLimit
                postEffect(
                    .showAlert(
                        title: "Capacity limit reached",
                        subtitle: "Remove \(overflowCount) member\(overflowCount == 1 ? "" : "s") to continue."
                    )
                )
                return
            }

            onNext(selectedMembers)

        case .callback(_, let onNext):
            let selectedFaculties = sourceFaculties
                .filter { state.selectedSectionIDs.contains($0.id) }
                .map(\.faculty)

            onNext(selectedFaculties)
        }
    }
}
