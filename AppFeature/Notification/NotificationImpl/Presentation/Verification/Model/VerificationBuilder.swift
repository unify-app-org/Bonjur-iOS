//
//  VerificationBuilder.swift
//  NotificationImpl
//
//  Created by Huseyn Hasanov on 28.06.26.
//

import UIKit

struct VerificationBuilder {
    private let inputData: VerificationInputData

    init(inputData: VerificationInputData) {
        self.inputData = inputData
    }

    func build() -> UIViewController {
        let router = VerificationRouter()
        let viewModel = VerificationViewModel(
            state: .init(),
            router: router,
            dependencies: .init(
                useCase: resolve()
            )
        )

        let controller = VerificationHostController(
            viewModel: viewModel
        ) { store in
            VerificationView(store: store)
        }

        router.view = controller
        return controller
    }
}
