//
//  FacultyStudentSelectListBuilder.swift
//  CommunitiesImpl
//
//  Created by aplle on 3/22/26.
//

import UIKit

// MARK: - FacultyStudentSelectList builder

struct FacultyStudentSelectListBuilder {
    private let inputData: FacultyStudentSelectListInputData
    
    init(inputData: FacultyStudentSelectListInputData) {
        self.inputData = inputData
    }
    
    func build() -> UIViewController {
        let router = FacultyStudentSelectListRouter()
        let viewModel = FacultyStudentSelectListViewModel(
            state: .init(),
            router: router,
            inputData: inputData,
            dependencies: .init()
        )
        
        let controller = FacultyStudentSelectListHostController(
            viewModel: viewModel
        ) { store in
            FacultyStudentSelectListView(store: store)
        }
        
        router.view = controller
        return controller
    }
}
