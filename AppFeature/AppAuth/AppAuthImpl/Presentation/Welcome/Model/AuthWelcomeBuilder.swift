//
//  AuthWelcomeBuilder.swift
//  AppAuthImpl
//
//  Created by Huseyn Hasanov on 26.12.25.
//

import UIKit

// MARK: - AuthWelcome builder

struct AuthWelcomeBuilder {
    private let inputData: AuthWelcomeInputData
    
    init(inputData: AuthWelcomeInputData) {
        self.inputData = inputData
    }
    
    func build() -> UIViewController {
        let router = AuthWelcomeRouter()
        let viewModel = AuthWelcomeViewModel(
            state: .init(),
            router: router,
            inputData: inputData,
            dependencies: .init(
                useCase: resolve(),
                userDefaults: resolve()
            )
        )
        
        let controller = AuthWelcomeHostController(
            viewModel: viewModel
        ) { store in
            AuthWelcomeView(store: store)
        }
        
        router.view = controller
        return controller
    }
}
