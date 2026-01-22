//
//  EventsListBuilder.swift
//  EventsImpl
//
//  Created by Huseyn Hasanov on 22.01.26.
//

import UIKit

// MARK: - EventsList builder

struct EventsListBuilder {
    private let inputData: EventsListInputData
    
    init(inputData: EventsListInputData) {
        self.inputData = inputData
    }
    
    func build() -> UIViewController {
        let router = EventsListRouter()
        let viewModel = EventsListViewModel(
            state: .init(),
            router: router,
            inputData: inputData,
            dependencies: .init(
                useCase: resolve()
            )
        )
        
        let controller = EventsListHostController(
            viewModel: viewModel
        ) { store in
            EventsListView(store: store)
        }
        
        router.view = controller
        return controller
    }
}
