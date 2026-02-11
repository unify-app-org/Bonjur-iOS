//
//  AppTabBarBuilder.swift
//  App
//
//  Created by Huseyn Hasanov on 01.01.26.
//  Copyright © 2026 Unify. All rights reserved.
//

import UIKit
import DependecyInjection
import Discover
import Clubs
import Groups
import Profile

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
            ),
            clubsModule: dependencyContainer.resolve(
                ClubsModule.self
            ),
            groupsModule: dependencyContainer.resolve(
                GroupsModule.self
            ),
            profileModule: dependencyContainer.resolve(
                ProfileModule.self
            )
        )
        
        router.view = controller
        return controller
    }
}
