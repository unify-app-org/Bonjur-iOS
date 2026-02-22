//
//  ClubCreateBuilder.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 21.02.26.
//

import UIKit

// MARK: - ClubCreate builder

struct ClubCreateBuilder {
    private let inputData: ClubCreateInputData
    
    init(inputData: ClubCreateInputData) {
        self.inputData = inputData
    }
    
    func build() -> UIViewController {
        let router = ClubCreateRouter()
        let viewModel = ClubCreateViewModel(
            state: .init(),
            router: router,
            inputData: inputData,
            dependencies: .init(
                useCase: resolve()
            )
        )
        
        let controller = ClubCreateHostController(
            viewModel: viewModel
        ) { store in
            ClubCreateView(store: store)
        }
        
        router.view = controller
        return controller
    }
}
