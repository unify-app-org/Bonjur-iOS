//
//  DiscoverViewModel.swift
//  DiscoverImpl
//
//  Created by Huseyn Hasanov on 11.01.26.
//

import AppFoundation

final class DiscoverViewModel: UIFeatureViewModel<DiscoverFeature> {
    
    struct Dependencies {
    }
    
    private let router: DiscoverRouterProtocol
    private let inputData: DiscoverInputData
    private let dependencies: DiscoverViewModel.Dependencies
    
    init(
        state: DiscoverFeature.State,
        router: DiscoverRouterProtocol,
        inputData: DiscoverInputData,
        dependencies: DiscoverViewModel.Dependencies
    ) {
        self.router = router
        self.inputData = inputData
        self.dependencies = dependencies
        super.init(initialState: state)
    }
    
    override func handle(action: DiscoverFeature.Action) {
    }
    
    private func fetchData() {
        
    }
}
