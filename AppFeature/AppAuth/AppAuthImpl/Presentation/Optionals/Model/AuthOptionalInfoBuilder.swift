//
//  AuthOptionalInfoBuilder.swift
//  AppAuthImpl
//
//  Created by Huseyn Hasanov on 26.12.25.
//

import UIKit

// MARK: - AuthOptionalInfo builder

struct AuthOptionalInfoBuilder {
    private let inputData: AuthOptionalInfoInputData
    
    init(inputData: AuthOptionalInfoInputData) {
        self.inputData = inputData
    }
    
    func build() -> UIViewController {
        let router = AuthOptionalInfoRouter()
        let viewModel = AuthOptionalInfoViewModel(
            state: .init(),
            router: router,
            inputData: inputData,
            dependencies: .init()
        )
        
        let controller = AuthOptionalInfoHostController(
            viewModel: viewModel
        ) { store in
            AuthOptionalInfoView(store: store)
        }
        
        router.view = controller
        return controller
    }
}
