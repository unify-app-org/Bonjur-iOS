//
//  ChooseUniversityBuilder.swift
//  AppAuthImpl
//
//  Created by Huseyn Hasanov on 26.12.25.
//

import UIKit

// MARK: - ChooseUniversity builder

struct ChooseUniversityBuilder {
    private let inputData: ChooseUniversityInputData
    
    init(inputData: ChooseUniversityInputData) {
        self.inputData = inputData
    }
    
    func build() -> UIViewController {
        let router = ChooseUniversityRouter()
        let viewModel = ChooseUniversityViewModel(
            state: .init(),
            router: router,
            inputData: inputData,
            dependencies: .init(
                useCase: resolve()
            )
        )
        
        let controller = ChooseUniversityHostController(
            viewModel: viewModel
        ) { store in
            ChooseUniversityView(store: store)
        }
        
        router.view = controller
        return controller
    }
}
