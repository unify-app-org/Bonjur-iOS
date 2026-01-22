//
//  EventsListViewModel.swift
//  EventsImpl
//
//  Created by Huseyn Hasanov on 22.01.26.
//

import AppFoundation

final class EventsListViewModel: UIFeatureViewModel<EventsListFeature> {
    
    struct Dependencies {
        let useCase: EventsUseCase
    }
    
    private let router: EventsListRouterProtocol
    private let inputData: EventsListInputData
    private let dependencies: EventsListViewModel.Dependencies
    
    init(
        state: EventsListFeature.State,
        router: EventsListRouterProtocol,
        inputData: EventsListInputData,
        dependencies: EventsListViewModel.Dependencies
    ) {
        self.router = router
        self.inputData = inputData
        self.dependencies = dependencies
        super.init(initialState: state)
    }
    
    override func handle(action: EventsListFeature.Action) {
        switch action {
        case .fetchData:
            fetchData()
        }
    }
    
    private func fetchData() {
        Task {
            await getEventsData()
        }
    }
    
    private func getEventsData() async {
        do {
            state.uiModel.events = try await dependencies.useCase.fetchEvenets()
        } catch {
            postEffect(.error(error))
        }
    }
}
