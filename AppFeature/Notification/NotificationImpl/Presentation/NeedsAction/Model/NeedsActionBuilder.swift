//
//  NeedsActionBuilder.swift
//  NotificationImpl
//
//  Created by Huseyn Hasanov on 28.06.26.
//

import UIKit

struct NeedsActionBuilder {
    private let inputData: NeedsActionInputData

    init(inputData: NeedsActionInputData) {
        self.inputData = inputData
    }

    func build() -> UIViewController {
        let router = NeedsActionRouter()
        let viewModel = NeedsActionViewModel(
            state: .init(),
            router: router,
            dependencies: .init(
                useCase: resolve(),
                userDefaults: resolve()
            )
        )

        let controller = NeedsActionHostController(
            viewModel: viewModel
        ) { store in
            NeedsActionView(store: store)
        }

        router.view = controller
        return controller
    }
}
