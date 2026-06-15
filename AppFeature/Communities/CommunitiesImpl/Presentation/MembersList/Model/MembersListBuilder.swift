//
//  MembersListBuilder.swift
//  CommunitiesImpl
//
//  Created by Claude on 15.06.26.
//

import UIKit

// MARK: - MembersList builder

struct MembersListBuilder {
    private let inputData: MembersListInputData

    init(inputData: MembersListInputData) {
        self.inputData = inputData
    }

    func build() -> UIViewController {
        let router = MembersListRouter()
        let viewModel = MembersListViewModel(
            state: .init(),
            router: router,
            inputData: inputData,
            dependencies: .init()
        )

        let controller = MembersListHostController(
            viewModel: viewModel
        ) { store in
            MembersListView(store: store)
        }

        router.view = controller
        return controller
    }
}
