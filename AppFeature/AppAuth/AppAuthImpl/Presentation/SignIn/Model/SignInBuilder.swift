//
//  SignInBuilder.swift
//  AppAuthImpl
//
//  Created by Huseyn Hasanov on 06.01.26.
//

import UIKit

// MARK: - SignIn builder

struct SignInBuilder {
    private let inputData: SignInInputData
    
    init(inputData: SignInInputData) {
        self.inputData = inputData
    }
    
    func build() -> UIViewController {
        let router = SignInRouter()
        let viewModel = SignInViewModel(
            state: .init(),
            router: router,
            inputData: inputData,
            dependencies: .init(
                useCase: resolve(),
                userDefaults: resolve()
            )
        )
        
        let controller = SignInHostController(
            viewModel: viewModel
        ) { store in
            SignInView(store: store)
        }
        
        router.view = controller
        return controller
    }
}
