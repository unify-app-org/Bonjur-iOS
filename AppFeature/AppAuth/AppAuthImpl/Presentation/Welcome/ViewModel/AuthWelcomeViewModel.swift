//
//  AuthWelcomeViewModel.swift
//  AppAuthImpl
//
//  Created by Huseyn Hasanov on 26.12.25.
//

import AppFoundation
import AppStorage

final class AuthWelcomeViewModel: UIFeatureViewModel<AuthWelcomeFeature> {
    
    struct Dependencies {
        let useCase: AuthUsecases
        let userDefaults: UserDefaultsProtocol
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
        case .continueTapped:
            Task {
                await router.navigate(to: .optional)
            }
        case .skipTapped:
            skipTapped()
        }
    }
    
    private func skipTapped() {
        dependencies.userDefaults.set(true, forKey: .isAuthenticated)
        Task {
            await router.navigate(to: .dashboard)
        }
    }
    
    private func fetchData() {
        state.uiModel = dependencies.useCase.welcome(name: inputData.name)
    }
}
