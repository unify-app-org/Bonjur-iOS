//
//  FacultyBrowseViewModel.swift
//  CommunitiesImpl
//
//  Created by aplle on 3/21/26.
//

import AppFoundation

final class FacultyBrowseViewModel: UIFeatureViewModel<FacultyBrowseFeature> {
    
    struct Dependencies {
    }
    
    private let router: FacultyBrowseRouterProtocol
    private let inputData: FacultyBrowseInputData
    private let dependencies: FacultyBrowseViewModel.Dependencies
    
    init(
        state: FacultyBrowseFeature.State,
        router: FacultyBrowseRouterProtocol,
        inputData: FacultyBrowseInputData,
        dependencies: FacultyBrowseViewModel.Dependencies
    ) {
        self.router = router
        self.inputData = inputData
        self.dependencies = dependencies
        super.init(initialState: state)
    }
    
    override func handle(action: FacultyBrowseFeature.Action) {
        switch action {
            case .onAppear:
                fetchData()

            case .facultyTapped(let faculty):
                inputData.onFacultyTapped(faculty)
            }
    }
    
    private func fetchData() {
        state.title = inputData.title
        state.sectionTitle = inputData.sectionTitle
        state.faculties = inputData.faculties
    }
}
