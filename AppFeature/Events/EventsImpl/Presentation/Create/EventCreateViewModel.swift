//
//  EventCreateViewModel.swift
//  EventsImpl
//
//  Created by Huseyn Hasanov on 21.02.26.
//

import AppFoundation

final class EventCreateViewModel: UIFeatureViewModel<EventCreateFeature> {
    
    struct Dependencies {
    }
    
    private let router: EventCreateRouterProtocol
    private let inputData: EventCreateInputData
    private let dependencies: EventCreateViewModel.Dependencies
    
    init(
        state: EventCreateFeature.State,
        router: EventCreateRouterProtocol,
        inputData: EventCreateInputData,
        dependencies: EventCreateViewModel.Dependencies
    ) {
        self.router = router
        self.inputData = inputData
        self.dependencies = dependencies
        super.init(initialState: state)
    }
    
    override func handle(action: EventCreateFeature.Action) {
    }
    
    private func fetchData() {
        
    }
}
