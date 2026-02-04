//
//  ProfileDetailViewModel.swift
//  ProfileImpl
//
//  Created by Huseyn Hasanov on 04.02.26.
//

import AppFoundation

final class ProfileDetailViewModel: UIFeatureViewModel<ProfileDetailFeature> {
    
    struct Dependencies {
    }
    
    private let router: ProfileDetailRouterProtocol
    private let inputData: ProfileDetailInputData
    private let dependencies: ProfileDetailViewModel.Dependencies
    
    init(
        state: ProfileDetailFeature.State,
        router: ProfileDetailRouterProtocol,
        inputData: ProfileDetailInputData,
        dependencies: ProfileDetailViewModel.Dependencies
    ) {
        self.router = router
        self.inputData = inputData
        self.dependencies = dependencies
        super.init(initialState: state)
    }
    
    override func handle(action: ProfileDetailFeature.Action) {
    }
    
    private func fetchData() {
        
    }
}
