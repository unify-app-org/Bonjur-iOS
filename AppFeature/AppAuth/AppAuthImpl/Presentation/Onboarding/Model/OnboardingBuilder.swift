//
//  OnboardingBuilder.swift
//  AppAuth
//
//  Created by Huseyn Hasanov on 23.12.25.
//

import UIKit

// MARK: - Onboarding builder

struct OnboardingBuilder {
    private let inputData: OnboardingInputData
    
    init(inputData: OnboardingInputData) {
        self.inputData = inputData
    }
    
    func build() -> UIViewController {
        let router = OnboardingRouter()
        let viewModel = OnboardingViewModel(
            state: .init(),
            router: router,
            inputData: inputData,
            dependencies: .init(
                useCase: resolve()
            )
        )
        
        let controller = OnboardingHostController(
            viewModel: viewModel
        ) { store in
            OnboardingView(store: store)
        }
        
        router.view = controller
        return controller
    }
}
