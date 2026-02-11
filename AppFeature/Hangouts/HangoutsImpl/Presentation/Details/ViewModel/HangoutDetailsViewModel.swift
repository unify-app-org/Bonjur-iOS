//
//  HangoutDetailsViewModel.swift
//  HangoutsImpl
//
//  Created by Huseyn Hasanov on 02.02.26.
//

import AppFoundation

final class HangoutDetailsViewModel: UIFeatureViewModel<HangoutDetailsFeature> {
    
    struct Dependencies {
        let useCase: HangoutsUseCase
    }
    
    private let router: HangoutDetailsRouterProtocol
    private let inputData: HangoutDetailsInputData
    private let dependencies: HangoutDetailsViewModel.Dependencies
    
    init(
        state: HangoutDetailsFeature.State,
        router: HangoutDetailsRouterProtocol,
        inputData: HangoutDetailsInputData,
        dependencies: HangoutDetailsViewModel.Dependencies
    ) {
        self.router = router
        self.inputData = inputData
        self.dependencies = dependencies
        super.init(initialState: state)
    }
    
    override func handle(action: HangoutDetailsFeature.Action) {
        switch action {
        case .backTapped:
            Task {
                await router.navigate(to: .back)
            }
        case .fetchData:
            fetchData()
        }
    }
    
    private func fetchData() {
        Task {
            await getHangoutDetail()
        }
    }
    
    private func getHangoutDetail() async {
        do {
            let data = try await dependencies.useCase.fetchDetailHangout(
                id: inputData.hangoutId
            )
            state.uiModel = data
        } catch {
            
        }
    }
}
