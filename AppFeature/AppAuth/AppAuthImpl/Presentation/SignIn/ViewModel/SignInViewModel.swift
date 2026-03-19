//
//  SignInViewModel.swift
//  AppAuthImpl
//
//  Created by Huseyn Hasanov on 06.01.26.
//

import AppFoundation

final class SignInViewModel: UIFeatureViewModel<SignInFeature> {
    
    struct Dependencies {
        let useCase: AuthUsecases
    }
    
    private let router: SignInRouterProtocol
    private let inputData: SignInInputData
    private let dependencies: SignInViewModel.Dependencies
    
    init(
        state: SignInFeature.State,
        router: SignInRouterProtocol,
        inputData: SignInInputData,
        dependencies: SignInViewModel.Dependencies
    ) {
        self.router = router
        self.inputData = inputData
        self.dependencies = dependencies
        super.init(initialState: state)
    }
    
    override func handle(action: SignInFeature.Action) {
        switch action {
        case .fetchData:
            fetchData()
        case .signIn:
            Task {
                await signIn()
            }
        }
    }
    
    private func fetchData() {
        
    }
    
    private func signIn() async {
        postEffect(.loading(true))
        defer {
            postEffect(.loading(false))
        }
        do {
            try await dependencies.useCase.login(email: state.email, password: state.password)
            await router.navigate(to: .home)
        } catch {
            state.error = .init(
                title: error.localizedDescription,
                subtitle: error.detail
            )
        }
    }
}
