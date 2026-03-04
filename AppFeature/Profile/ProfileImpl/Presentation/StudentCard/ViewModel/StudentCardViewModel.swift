//
//  StudentCardViewModel.swift
//  ProfileImpl
//
//  Created by aplle on 3/4/26.
//

import AppFoundation

final class StudentCardViewModel: UIFeatureViewModel<StudentCardFeature> {
    
    struct Dependencies {
    }
    
    private let router: StudentCardRouterProtocol
    private let inputData: StudentCardInputData
    private let dependencies: StudentCardViewModel.Dependencies
    
    init(
        state: StudentCardFeature.State,
        router: StudentCardRouterProtocol,
        inputData: StudentCardInputData,
        dependencies: StudentCardViewModel.Dependencies
    ) {
        self.router = router
        self.inputData = inputData
        self.dependencies = dependencies
        super.init(initialState: state)
    }
    
    override func handle(action: StudentCardFeature.Action) {
    }
    
    private func fetchData() {
        
    }
}
