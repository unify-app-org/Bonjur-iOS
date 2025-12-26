//
//  AuthOptionalInfoViewModel.swift
//  AppAuthImpl
//
//  Created by Huseyn Hasanov on 26.12.25.
//

import AppFoundation

final class AuthOptionalInfoViewModel: UIFeatureViewModel<AuthOptionalInfoFeature> {
    
    struct Dependencies {
    }
    
    private let router: AuthOptionalInfoRouterProtocol
    private let inputData: AuthOptionalInfoInputData
    private let dependencies: AuthOptionalInfoViewModel.Dependencies
    
    init(
        state: AuthOptionalInfoFeature.State,
        router: AuthOptionalInfoRouterProtocol,
        inputData: AuthOptionalInfoInputData,
        dependencies: AuthOptionalInfoViewModel.Dependencies
    ) {
        self.router = router
        self.inputData = inputData
        self.dependencies = dependencies
        super.init(initialState: state)
    }
    
    override func handle(action: AuthOptionalInfoFeature.Action) {
    }
    
    private func fetchData() {
        
    }
}
