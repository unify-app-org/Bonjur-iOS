//
//  ProfileDetailBuilder.swift
//  ProfileImpl
//
//  Created by Huseyn Hasanov on 04.02.26.
//

import UIKit

// MARK: - ProfileDetail builder

struct ProfileDetailBuilder {
    private let inputData: ProfileDetailInputData
    
    init(inputData: ProfileDetailInputData) {
        self.inputData = inputData
    }
    
    func build() -> UIViewController {
        let router = ProfileDetailRouter()
        let viewModel = ProfileDetailViewModel(
            state: .init(),
            router: router,
            inputData: inputData,
            dependencies: .init()
        )
        
        let controller = ProfileDetailHostController(
            viewModel: viewModel
        ) { store in
            ProfileDetailView(store: store)
        }
        
        router.view = controller
        return controller
    }
}
