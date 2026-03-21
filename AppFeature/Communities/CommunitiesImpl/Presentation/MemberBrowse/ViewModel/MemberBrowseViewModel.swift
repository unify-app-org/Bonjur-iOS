//
//  MemberBrowseViewModel.swift
//  CommunitiesImpl
//
//  Created by aplle on 3/21/26.
//

import AppFoundation

final class MemberBrowseViewModel: UIFeatureViewModel<MemberBrowseFeature> {
    
    struct Dependencies {
    }
    
    private let router: MemberBrowseRouterProtocol
    private let inputData: MemberBrowseInputData
    private let dependencies: MemberBrowseViewModel.Dependencies
    
    init(
        state: MemberBrowseFeature.State,
        router: MemberBrowseRouterProtocol,
        inputData: MemberBrowseInputData,
        dependencies: MemberBrowseViewModel.Dependencies
    ) {
        self.router = router
        self.inputData = inputData
        self.dependencies = dependencies
        super.init(initialState: state)
    }
    
    override func handle(action: MemberBrowseFeature.Action) {
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
