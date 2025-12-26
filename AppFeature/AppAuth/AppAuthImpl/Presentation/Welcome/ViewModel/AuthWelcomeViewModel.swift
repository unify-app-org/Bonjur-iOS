//
//  AuthWelcomeViewModel.swift
//  AppAuthImpl
//
//  Created by Huseyn Hasanov on 26.12.25.
//

import AppFoundation

final class AuthWelcomeViewModel: UIFeatureViewModel<AuthWelcomeFeature> {
    
    struct Dependencies {
        let useCase: AuthUsecases
    }
    
    private let router: AuthWelcomeRouterProtocol
    private let inputData: AuthWelcomeInputData
    private let dependencies: AuthWelcomeViewModel.Dependencies
    
    init(
        state: AuthWelcomeFeature.State,
        router: AuthWelcomeRouterProtocol,
        inputData: AuthWelcomeInputData,
        dependencies: AuthWelcomeViewModel.Dependencies
    ) {
        self.router = router
        self.inputData = inputData
        self.dependencies = dependencies
        super.init(initialState: state)
    }
    
    override func handle(action: AuthWelcomeFeature.Action) {
        switch action {
        case .fetchData:
            fetchData()
        case .dismiss:
            Task {
                await router.navigate(to: .dismiss)
            }
        case .continueTapped:
            Task {
                await router.navigate(to: .optional)
            }
        }
    }
    
    private func fetchData() {
        state.uiModel = dependencies.useCase.welcome(name: inputData.name)
    }
}
