//
//  RegisterViewModel.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 25.11.25.
//

import AppFoundation

final class RegisterViewModel: UIFeatureViewModel<RegisterFeature> {
    
    struct Dependencies {
        let useCase: AuthUsecases
    }
    
    private let router: RegsiterRouter
    private let inputData: RegisterInputData
    private let dependencies: RegisterViewModel.Dependencies
    
    init(
        state: RegisterFeature.State,
        router: RegsiterRouter,
        inputData: RegisterInputData,
        dependencies: RegisterViewModel.Dependencies
    ) {
        self.router = router
        self.inputData = inputData
        self.dependencies = dependencies
        super.init(initialState: state)
    }
    
    override func handle(action: RegisterAction) {
        switch action {
        case .fetchData:
            fetchData()
        case .registerTapped:
            Task {
                await route(to: .otp(email: state.email))
            }
        }
    }
    
    private func fetchData() {
        Task {
            await continueTapped()
        }
    }
    
    @MainActor
    private func continueTapped() {
        Task {
            try await sendOtp()
        }
    }
    
    private func sendOtp() async throws {
        do {
            let _ = try await dependencies.useCase.register(body: .init())
        } catch {
            
        }
    }
    
    @MainActor
    private func route(to: RegisterRouting) {
        router.navigate(to: to)
    }
}
