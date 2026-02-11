//
//  OnboardingViewModel.swift
//  AppAuth
//
//  Created by Huseyn Hasanov on 23.12.25.
//

import AppFoundation

final class OnboardingViewModel: UIFeatureViewModel<OnboardingFeature> {
    
    struct Dependencies {
        let useCase: AuthUsecases
    }
    
    private let router: OnboardingRouterProtocol
    private let inputData: OnboardingInputData
    private let dependencies: OnboardingViewModel.Dependencies
    
    init(
        state: OnboardingFeature.State,
        router: OnboardingRouterProtocol,
        inputData: OnboardingInputData,
        dependencies: OnboardingViewModel.Dependencies
    ) {
        self.router = router
        self.inputData = inputData
        self.dependencies = dependencies
        super.init(initialState: state)
    }
    
    override func handle(action: OnboardingFeature.Action) {
        switch action {
        case .fetchData:
            fetchData()
        case .skipOnboarding:
            Task {
                await router.navigate(to: .chooseUniversity)
            }
        }
    }
    
    private func fetchData() {
        state.uiModel = dependencies.useCase.onboarding()
    }
}
