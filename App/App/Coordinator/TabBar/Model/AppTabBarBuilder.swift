//
//  AppTabBarBuilder.swift
//  App
//
//  Created by Huseyn Hasanov on 01.01.26.
//  Copyright © 2026 Bonjur. All rights reserved.
//

import UIKit

// MARK: - AppTabBar builder

struct AppTabBarBuilder {
    private let inputData: AppTabBarInputData
    
    init(inputData: AppTabBarInputData) {
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
            viewModel: viewModel
        ) { store in
            AppTabBarView(store: store)
        }
        
        router.view = controller
        return controller
    }
}
