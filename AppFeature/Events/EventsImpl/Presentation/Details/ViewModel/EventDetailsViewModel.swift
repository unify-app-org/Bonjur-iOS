//
//  EventDetailsViewModel.swift
//  EventsImpl
//
//  Created by Huseyn Hasanov on 01.02.26.
//

import AppFoundation

final class EventDetailsViewModel: UIFeatureViewModel<EventDetailsFeature> {
    
    struct Dependencies {
        let useCase: EventsUseCase
    }
    
    private let router: EventDetailsRouterProtocol
    private let inputData: EventDetailsInputData
    private let dependencies: EventDetailsViewModel.Dependencies
    
    init(
        state: EventDetailsFeature.State,
        router: EventDetailsRouterProtocol,
        inputData: EventDetailsInputData,
        dependencies: EventDetailsViewModel.Dependencies
    ) {
        self.router = router
        self.inputData = inputData
        self.dependencies = dependencies
        super.init(initialState: state)
    }
    
    override func handle(action: EventDetailsFeature.Action) {
        switch action {
        case .fetchData:
            fetchData()
        case .backTapped:
            Task {
                await router.navigate(to: .backTapped)
            }
        }
    }
    
    private func fetchData() {
        Task {
            await getDetails()
        }
    }
    
    private func getDetails() async {
        do {
            let data = try await dependencies.useCase.fetchEventDetail(
                eventId: inputData.eventId
            )
            state.uiModel = data
        } catch {
            
        }
    }
}
