//
//  DiscoverBuilder.swift
//  DiscoverImpl
//
//  Created by Huseyn Hasanov on 11.01.26.
//

import UIKit

// MARK: - Discover builder

struct DiscoverBuilder {
    private let inputData: DiscoverInputData
    
    init(inputData: DiscoverInputData) {
        self.inputData = inputData
    }
    
    func build() -> UIViewController {
        let router = DiscoverRouter()
        let viewModel = DiscoverViewModel(
            state: .init(),
            router: router,
            inputData: inputData,
            dependencies: .init(
                useCase: resolve()
            )
        )
        
        let controller = DiscoverHostController(
            viewModel: viewModel
        ) { store in
            DiscoverView(store: store)
        }
        
        router.view = controller
        return controller
    }
}
