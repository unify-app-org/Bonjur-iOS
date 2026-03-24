//
//  MemberSelectionBuilder.swift
//  CommunitiesImpl
//
//  Created by aplle on 3/23/26.
//

import UIKit

// MARK: - MemberSelection builder

struct MemberSelectionBuilder {
    private let inputData: MemberSelectionInputData
    
    init(inputData: MemberSelectionInputData) {
        self.inputData = inputData
    }
    
    func build() -> UIViewController {
        let router = MemberSelectionRouter()
        let viewModel = MemberSelectionViewModel(
            state: .init(),
            router: router,
            inputData: inputData,
            dependencies: .init()
        )
        
        let controller = MemberSelectionHostController(
            viewModel: viewModel
        ) { store in
            MemberSelectionView(store: store)
        }
        
        router.view = controller
        return controller
    }
}
