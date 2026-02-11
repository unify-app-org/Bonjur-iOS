//
//  ClubsBuilder.swift
//  ClubsImpl
//
//  Created by Huseyn Hasanov on 17.01.26.
//

import UIKit

// MARK: - Clubs builder

struct ClubsBuilder {
    private let inputData: ClubsInputData
    
    init(inputData: ClubsInputData) {
        self.inputData = inputData
    }
    
    func build() -> UIViewController {
        let router = ClubsRouter()
        let viewModel = ClubsViewModel(
            state: .init(),
            router: router,
            inputData: inputData,
            dependencies: .init(
                useCase: resolve()
            )
        )
        
        let controller = ClubsHostController(
            viewModel: viewModel
        ) { store in
            ClubsView(store: store)
        }
        
        router.view = controller
        return controller
    }
}
