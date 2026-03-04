//
//  StudentCardBuilder.swift
//  ProfileImpl
//
//  Created by aplle on 3/4/26.
//

import UIKit

// MARK: - StudentCard builder

struct StudentCardBuilder {
    private let inputData: StudentCardInputData
    
    init(inputData: StudentCardInputData) {
        self.inputData = inputData
    }
    
    func build() -> UIViewController {
        let router = StudentCardRouter()
        let viewModel = StudentCardViewModel(
            state: .init(),
            router: router,
            inputData: inputData,
            dependencies: .init()
        )
        
        let controller = StudentCardHostController(
            viewModel: viewModel
        ) { store in
            StudentCardView(store: store)
        }
        
        router.view = controller
        return controller
    }
}
