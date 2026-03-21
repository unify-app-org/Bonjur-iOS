//
//  MemberBrowseBuilder.swift
//  CommunitiesImpl
//
//  Created by aplle on 3/21/26.
//

import UIKit

// MARK: - MemberBrowse builder

struct MemberBrowseBuilder {
    private let inputData: MemberBrowseInputData
    
    init(inputData: MemberBrowseInputData) {
        self.inputData = inputData
    }
    
    func build() -> UIViewController {
        let router = MemberBrowseRouter()
        let viewModel = MemberBrowseViewModel(
            state: .init(),
            router: router,
            inputData: inputData,
            dependencies: .init()
        )
        
        let controller = MemberBrowseHostController(
            viewModel: viewModel
        ) { store in
            MemberBrowseView(store: store)
        }
        
        router.view = controller
        return controller
    }
}
