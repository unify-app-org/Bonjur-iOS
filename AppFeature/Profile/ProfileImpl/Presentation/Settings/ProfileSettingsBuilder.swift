//
//  ProfileSettingsBuilder.swift
//  AppFeature
//
//  Created by Nahid Askerli on 26.02.26.
//

import UIKit

// MARK: - ProfileSettings builder

struct ProfileSettingsBuilder {
    private let inputData: ProfileSettingsInputData
    
    init(inputData: ProfileSettingsInputData) {
        self.inputData = inputData
    }
    
    func build() -> UIViewController {
        let router = ProfileSettingsRouter()
        let viewModel = ProfileSettingsViewModel(
            state: .init(),
            router: router,
            inputData: inputData,
            dependencies: .init()
        )
        
        let controller = ProfileSettingsHostController(
            viewModel: viewModel
        ) { store in
            ProfileSettingsView(store: store)
        }
        
        router.view = controller
        return controller
    }
}
