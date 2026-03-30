//
//  ProfileSettingsViewModel.swift
//  AppFeature
//
//  Created by Nahid Askerli on 26.02.26.
//

import AppFoundation

final class ProfileSettingsViewModel: UIFeatureViewModel<ProfileSettingsFeature> {
    
    struct Dependencies {
    }
    
    private let router: ProfileSettingsRouterProtocol
    private let inputData: ProfileSettingsInputData
    private let dependencies: ProfileSettingsViewModel.Dependencies
    
    init(
        state: ProfileSettingsFeature.State,
        router: ProfileSettingsRouterProtocol,
        inputData: ProfileSettingsInputData,
        dependencies: ProfileSettingsViewModel.Dependencies
    ) {
        self.router = router
        self.inputData = inputData
        self.dependencies = dependencies
        super.init(initialState: state)
    }
    
    override func handle(action: ProfileSettingsFeature.Action) {
    }
    
    private func fetchData() {
        
    }
}
