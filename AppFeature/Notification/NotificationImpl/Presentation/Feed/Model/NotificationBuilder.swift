//
//  NotificationBuilder.swift
//  NotificationImpl
//
//  Created by Huseyn Hasanov on 27.06.26.
//

import UIKit

// MARK: - Notification builder

struct NotificationBuilder {
    private let inputData: NotificationInputData

    init(inputData: NotificationInputData) {
        self.inputData = inputData
    }

    func build() -> UIViewController {
        let router = NotificationRouter()
        let viewModel = NotificationViewModel(
            state: .init(),
            router: router,
            inputData: inputData,
            dependencies: .init(
                useCase: resolve(),
                needsActionUseCase: resolve()
            )
        )

        let controller = NotificationHostController(
            viewModel: viewModel
        ) { store in
            NotificationView(store: store)
        }

        router.view = controller
        return controller
    }
}
