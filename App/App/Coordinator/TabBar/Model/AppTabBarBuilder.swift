//
//  AppTabBarBuilder.swift
//  App
//
//  Created by Huseyn Hasanov on 01.01.26.
//  Copyright © 2026 Bonjur. All rights reserved.
//

import UIKit
import DependecyInjection
import Discover

// MARK: - AppTabBar builder

struct AppTabBarBuilder {
    private let inputData: AppTabBarInputData
    private var dependencyContainer: AppDIContainer
    
    init(
        inputData: AppTabBarInputData,
        dependencyContainer: AppDIContainer
    ) {
        self.dependencyContainer = dependencyContainer
        self.inputData = inputData
    }
    
    func build() -> UIViewController {
        let router = AppTabBarRouter()
        let viewModel = AppTabBarViewModel(
            state: .init(),
            router: router,
            inputData: inputData,
            dependencies: .init()
        )
        
        let controller = AppTabBarHostController(
            viewModel: viewModel,
            discoverModule: dependencyContainer.resolve(
                DiscoverModule.self
            )
        )
        
        router.view = controller
        return controller
    }
}
