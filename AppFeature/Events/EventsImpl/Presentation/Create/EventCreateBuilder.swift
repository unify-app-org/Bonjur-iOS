//
//  EventCreateBuilder.swift
//  EventsImpl
//
//  Created by Huseyn Hasanov on 21.02.26.
//

import UIKit

// MARK: - EventCreate builder

struct EventCreateBuilder {
    private let inputData: EventCreateInputData
    
    init(inputData: EventCreateInputData) {
        self.inputData = inputData
    }
    
    func build() -> UIViewController {
        let router = EventCreateRouter()
        let viewModel = EventCreateViewModel(
            state: .init(),
            router: router,
            inputData: inputData,
            dependencies: .init()
        )
        
        let controller = EventCreateHostController(
            viewModel: viewModel
        ) { store in
            EventCreateView(store: store)
        }
        
        router.view = controller
        return controller
    }
}
