//
//  EventDetailsBuilder.swift
//  EventsImpl
//
//  Created by Huseyn Hasanov on 01.02.26.
//

import UIKit

// MARK: - EventDetails builder

struct EventDetailsBuilder {
    private let inputData: EventDetailsInputData
    
    init(inputData: EventDetailsInputData) {
        self.inputData = inputData
    }
    
    func build() -> UIViewController {
        let router = EventDetailsRouter()
        let viewModel = EventDetailsViewModel(
            state: .init(),
            router: router,
            inputData: inputData,
            dependencies: .init(useCase: resolve())
        )
        
        let controller = EventDetailsHostController(
            viewModel: viewModel
        ) { store in
            EventDetailsView(store: store)
        }
        
        router.view = controller
        return controller
    }
}
