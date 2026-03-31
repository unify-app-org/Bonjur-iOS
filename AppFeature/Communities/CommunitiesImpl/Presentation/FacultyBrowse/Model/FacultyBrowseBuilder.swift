//
//  FacultyBrowseBuilder.swift
//  CommunitiesImpl
//
//  Created by aplle on 3/21/26.
//

import UIKit

// MARK: - FacultyBrowse builder

struct FacultyBrowseBuilder {
    private let inputData: FacultyBrowseInputData
    
    init(inputData: FacultyBrowseInputData) {
        self.inputData = inputData
    }
    
    func build() -> UIViewController {
        let router = FacultyBrowseRouter()
        let viewModel = FacultyBrowseViewModel(
            state: .init(),
            router: router,
            inputData: inputData,
            dependencies: .init()
        )
        
        let controller = FacultyBrowseHostController(
            viewModel: viewModel
        ) { store in
            FacultyBrowseView(store: store)
        }
        
        router.view = controller
        return controller
    }
}
