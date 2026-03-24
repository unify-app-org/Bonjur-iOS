//
//  MemberSelectionViewModel.swift
//  CommunitiesImpl
//
//  Created by aplle on 3/23/26.
//

import AppFoundation
import Communities

final class MemberSelectionViewModel: UIFeatureViewModel<MemberSelectionFeature> {

    struct Dependencies {
    }

    private struct SourceSection {
        let id: String
        let title: String
        let members: [CommunitiesMemberModuleModel.MemberCellModel]
    }

    private let router: MemberSelectionRouterProtocol
    private let inputData: MemberSelectionInputData
    private let dependencies: Dependencies
    private var sourceSections: [SourceSection] = []

    init(
        state: MemberSelectionFeature.State,
        router: MemberSelectionRouterProtocol,
        inputData: MemberSelectionInputData,
        dependencies: Dependencies
    ) {
        self.router = router
        self.inputData = inputData
        self.dependencies = dependencies
        super.init(initialState: state)
    }

    override func handle(action: MemberSelectionFeature.Action) {
        switch action {
        case .onAppear:
            fetchData()

        case .rowTapped(let row):
            toggleSelection(for: row.id)

        case .nextTapped:
            continueSelection()

        case .skipTapped:
            inputData.onSkip()
        }
    }

    private func fetchData() {
        state.title = inputData.title
        state.sectionTitle = inputData.sectionTitle
        sourceSections = inputData.sections.enumerated().map { index, section in
            SourceSection(
                id: "section-\(index)",
                title: section.title,
                members: section.members
            )
        }
        rebuildRows()
    }

    private func rebuildRows() {
        state.rows = sourceSections.map { section in
            FacultyRowViewData(
                id: section.id,
                title: section.title,
                accessory: .selectable(
                    isSelected: state.selectedSectionIDs.contains(section.id)
                )
            )
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

    private func continueSelection() {
        let selectedMembers = sourceSections
            .filter { state.selectedSectionIDs.contains($0.id) }
            .flatMap(\.members)

        if let limit = inputData.capacityLimit, selectedMembers.count > limit {
            postEffect(.capacityLimitReached(overflowCount: selectedMembers.count - limit))
            return
        }

        inputData.onNext(selectedMembers)
    }
}
