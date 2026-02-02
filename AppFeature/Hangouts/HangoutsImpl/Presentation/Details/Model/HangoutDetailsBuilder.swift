//
//  HangoutDetailsBuilder.swift
//  HangoutsImpl
//
//  Created by Huseyn Hasanov on 02.02.26.
//

import UIKit

// MARK: - HangoutDetails builder

struct HangoutDetailsBuilder {
    private let inputData: HangoutDetailsInputData
    
    init(inputData: HangoutDetailsInputData) {
        self.inputData = inputData
    }
    
    func build() -> UIViewController {
        let router = HangoutDetailsRouter()
        let viewModel = HangoutDetailsViewModel(
            state: .init(),
            router: router,
            inputData: inputData,
            dependencies: .init(
                useCase: resolve()
            )
        )
        
        let controller = HangoutDetailsHostController(
            viewModel: viewModel
        ) { store in
            HangoutDetailsView(store: store)
        }
        
        router.view = controller
        return controller
    }
}
