//
//  ClubDetailsBuilder.swift
//  AppAuth
//
//  Created by Huseyn Hasanov on 29.01.26.
//

import UIKit

// MARK: - ClubDetails builder

struct ClubDetailsBuilder {
    private let inputData: ClubDetailsInputData
    
    init(inputData: ClubDetailsInputData) {
        self.inputData = inputData
    }
    
    func build() -> UIViewController {
        let router = ClubDetailsRouter()
        let viewModel = ClubDetailsViewModel(
            state: .init(),
            router: router,
            inputData: inputData,
            dependencies: .init(
                useCase: resolve()
            )
        )
        
        let controller = ClubDetailsHostController(
            viewModel: viewModel
        ) { store in
            ClubDetailsView(store: store)
        }
        
        router.view = controller
        return controller
    }
}
