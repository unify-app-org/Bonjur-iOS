//
//  HangoutListBuilder.swift
//  HangoutsImpl
//
//  Created by Huseyn Hasanov on 22.01.26.
//

import UIKit

// MARK: - HangoutList builder

struct HangoutListBuilder {
    private let inputData: HangoutListInputData
    
    init(inputData: HangoutListInputData) {
        self.inputData = inputData
    }
    
    func build() -> UIViewController {
        let router = HangoutListRouter()
        let viewModel = HangoutListViewModel(
            state: .init(),
            router: router,
            inputData: inputData,
            dependencies: .init(
                useCase: resolve()
            )
        )
        
        let controller = HangoutListHostController(
            viewModel: viewModel
        ) { store in
            HangoutListView(store: store)
        }
        
        router.view = controller
        return controller
    }
}
