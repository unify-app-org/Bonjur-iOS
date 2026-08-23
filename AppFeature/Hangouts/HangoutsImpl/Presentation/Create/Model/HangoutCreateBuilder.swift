//
//  HangoutCreateBuilder.swift
//  AppFeature
//
//  Created by Codex on 30.05.26.
//

import UIKit

// MARK: - HangoutCreate builder

struct HangoutCreateBuilder {
    private let inputData: HangoutCreateInputData
    
    init(inputData: HangoutCreateInputData) {
        self.inputData = inputData
    }
    
    func build() -> UIViewController {
        let router = HangoutCreateRouter()
        let viewModel = HangoutCreateViewModel(
            state: .init(),
            router: router,
            inputData: inputData,
            dependencies: .init(
                useCase: resolve(),
                tokenManager: resolve()
            )
        )
        
        let controller = HangoutCreateHostController(
            viewModel: viewModel
        ) { store in
            HangoutCreateView(store: store)
        }
        
        router.view = controller
        return controller
    }
}
