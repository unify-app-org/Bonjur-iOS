//
//  CommunityDetailBuilder.swift
//  CommunitiesImpl
//
//  Created by Huseyn Hasanov on 03.02.26.
//

import UIKit

// MARK: - CommunityDetail builder

struct CommunityDetailBuilder {
    private let inputData: CommunityDetailInputData
    
    init(inputData: CommunityDetailInputData) {
        self.inputData = inputData
    }
    
    func build() -> UIViewController {
        let router = CommunityDetailRouter()
        let viewModel = CommunityDetailViewModel(
            state: .init(),
            router: router,
            inputData: inputData,
            dependencies: .init(
                useCase: resolve()
            )
        )
        
        let controller = CommunityDetailHostController(
            viewModel: viewModel
        ) { store in
            CommunityDetailView(store: store)
        }
        
        router.view = controller
        return controller
    }
}
