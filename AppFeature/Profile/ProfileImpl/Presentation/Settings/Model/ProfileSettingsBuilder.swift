//
//  ProfileSettingsBuilder.swift
//  ProfileImpl
//
//  Created by Nahid Askerli on 26.03.26.
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
            dependencies: .init(
                useCase: resolve()
            )
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
