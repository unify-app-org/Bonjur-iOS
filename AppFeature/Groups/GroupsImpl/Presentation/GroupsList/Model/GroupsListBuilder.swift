//
//  GroupsListBuilder.swift
//  GroupsImpl
//
//  Created by Huseyn Hasanov on 23.01.26.
//

import UIKit

// MARK: - GroupsList builder

struct GroupsListBuilder {
    private let inputData: GroupsListInputData
    
    init(inputData: GroupsListInputData) {
        self.inputData = inputData
    }
    
    func build() -> UIViewController {
        let router = GroupsListRouter()
        let viewModel = GroupsListViewModel(
            state: .init(),
            router: router,
            inputData: inputData,
            dependencies: .init(
                useCase: resolve()
            )
        )
        
        let controller = GroupsListHostController(
            viewModel: viewModel
        ) { store in
            GroupsListView(store: store)
        }
        
        router.view = controller
        return controller
    }
}
