//
//  EditProfileBuilder.swift
//  ProfileImpl
//
//  Created by Huseyn Hasanov on 11.05.26.
//

import UIKit

// MARK: - EditProfile builder

struct EditProfileBuilder {
    private let inputData: EditProfileInputData
    
    init(inputData: EditProfileInputData) {
        self.inputData = inputData
    }
    
    func build() -> UIViewController {
        let router = EditProfileRouter()
        let viewModel = EditProfileViewModel(
            state: .init(),
            router: router,
            inputData: inputData,
            dependencies: .init(
                useCase: resolve()
            )
        )
        
        let controller = EditProfileHostController(
            viewModel: viewModel
        ) { store in
            EditProfileView(store: store)
        }
        controller.hidesBottomBarWhenPushed = true
        
        router.view = controller
        return controller
    }
}
