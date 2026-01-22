//
//  HangoutListViewModel.swift
//  HangoutsImpl
//
//  Created by Huseyn Hasanov on 22.01.26.
//

import AppFoundation

final class HangoutListViewModel: UIFeatureViewModel<HangoutListFeature> {
    
    struct Dependencies {
        let useCase: HangoutsUseCase
    }
    
    private let router: HangoutListRouterProtocol
    private let inputData: HangoutListInputData
    private let dependencies: HangoutListViewModel.Dependencies
    
    init(
        state: HangoutListFeature.State,
        router: HangoutListRouterProtocol,
        inputData: HangoutListInputData,
        dependencies: HangoutListViewModel.Dependencies
    ) {
        self.router = router
        self.inputData = inputData
        self.dependencies = dependencies
        super.init(initialState: state)
    }
    
    override func handle(action: HangoutListFeature.Action) {
        switch action {
        case .fetchData:
            fetchData()
        }
    }
    
    private func fetchData() {
        Task {
            await getHangoutsData()
        }
    }
    
    private func getHangoutsData() async {
        do {
            state.uiModel.hangouts = try await dependencies.useCase.fetchHangouts()
        } catch {
            postEffect(.error(error))
        }
    }
}
