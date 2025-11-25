//
//  RegisterBuilder.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 25.11.25.
//

import UIKit

final class RegisterBuilder {
    func build(
        inputData: RegisterInputData
    ) -> UIViewController {
        let router = RegisterRouterImpl()
        let viewModel = RegisterViewModel(
            state: .init(),
            router: router,
            inputData: inputData,
            dependencies: .init(
                useCase: resolve()
            )
        )
        let controller = RegisterViewController(
            viewModel: viewModel
        ) { store in
            RegisterView(store: store)
        }
        
        router.view = controller
        return controller
    }
}
