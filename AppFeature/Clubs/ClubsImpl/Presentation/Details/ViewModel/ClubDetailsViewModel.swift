//
//  ClubDetailsViewModel.swift
//  AppAuth
//
//  Created by Huseyn Hasanov on 29.01.26.
//

import AppFoundation

final class ClubDetailsViewModel: UIFeatureViewModel<ClubDetailsFeature> {
    
    struct Dependencies {
    }
    
    private let router: ClubDetailsRouterProtocol
    private let inputData: ClubDetailsInputData
    private let dependencies: ClubDetailsViewModel.Dependencies
    
    init(
        state: ClubDetailsFeature.State,
        router: ClubDetailsRouterProtocol,
        inputData: ClubDetailsInputData,
        dependencies: ClubDetailsViewModel.Dependencies
    ) {
        self.router = router
        self.inputData = inputData
        self.dependencies = dependencies
        super.init(initialState: state)
    }
    
    override func handle(action: ClubDetailsFeature.Action) {
    }
    
    private func fetchData() {
        
    }
}
