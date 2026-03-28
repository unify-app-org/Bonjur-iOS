//
//  FacultySelectionBuilder.swift
//  CommunitiesImpl
//
//  Created by aplle on 3/23/26.
//

import UIKit

// MARK: - FacultySelection builder

struct FacultySelectionBuilder {
    private let inputData: FacultySelectionInputData
    
    init(inputData: FacultySelectionInputData) {
        self.inputData = inputData
    }
    
    func build() -> UIViewController {
        let router = FacultySelectionRouter()
        let viewModel = FacultySelectionViewModel(
            state: .init(),
            router: router,
            inputData: inputData,
            dependencies: .init()
        )
        
        let controller = FacultySelectionHostController(
            viewModel: viewModel
        ) { store in
            FacultySelectionView(store: store)
        }
        
        router.view = controller
        return controller
    }
}
