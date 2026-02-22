//
//  AppTabBarViewModel.swift
//  App
//
//  Created by Huseyn Hasanov on 01.01.26.
//  Copyright © 2026 Unify. All rights reserved.
//

import AppFoundation

final class AppTabBarViewModel: UIFeatureViewModel<AppTabBarFeature> {
    
    var lastSelectedIndex: Int = 0
    
    struct Dependencies {
    }
    
    private let router: AppTabBarRouterProtocol
    private let inputData: AppTabBarInputData
    private let dependencies: AppTabBarViewModel.Dependencies
    
    init(
        state: AppTabBarFeature.State,
        router: AppTabBarRouterProtocol,
        inputData: AppTabBarInputData,
        dependencies: AppTabBarViewModel.Dependencies
    ) {
        self.router = router
        self.inputData = inputData
        self.dependencies = dependencies
        super.init(initialState: state)
    }
    
    override func handle(action: AppTabBarFeature.Action) {
    }
    
    private func fetchData() {
        
    }
}
