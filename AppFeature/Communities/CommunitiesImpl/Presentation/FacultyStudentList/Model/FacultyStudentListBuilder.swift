//
//  FacultyStudentListBuilder.swift
//  CommunitiesImpl
//
//  Created by aplle on 3/22/26.
//

import UIKit

// MARK: - FacultyStudentList builder

struct FacultyStudentListBuilder {
    private let inputData: FacultyStudentListInputData
    
    init(inputData: FacultyStudentListInputData) {
        self.inputData = inputData
    }
    
    func build() -> UIViewController {
        let router = FacultyStudentListRouter()
        let viewModel = FacultyStudentListViewModel(
            state: .init(),
            router: router,
            inputData: inputData,
            dependencies: .init()
        )
        
        let controller = FacultyStudentListHostController(
            viewModel: viewModel
        ) { store in
            FacultyStudentListView(store: store)
        }
        
        router.view = controller
        return controller
    }
}
