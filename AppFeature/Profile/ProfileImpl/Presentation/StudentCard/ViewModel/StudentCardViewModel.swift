//
//  StudentCardViewModel.swift
//  ProfileImpl
//
//  Created by aplle on 3/4/26.
//

import AppFoundation

final class StudentCardViewModel: UIFeatureViewModel<StudentCardFeature> {
    
    struct Dependencies {
    }
    
    private let router: StudentCardRouterProtocol
    private let inputData: StudentCardInputData
    private let dependencies: StudentCardViewModel.Dependencies
    
    init(
        state: StudentCardFeature.State,
        router: StudentCardRouterProtocol,
        inputData: StudentCardInputData,
        dependencies: StudentCardViewModel.Dependencies
    ) {
        self.router = router
        self.inputData = inputData
        self.dependencies = dependencies
        super.init(initialState: state)
        
        self.state.previewCard = inputData.userCardModel
        self.state.savedCover = inputData.userCardModel.backgroundCover
        self.state.selectedCover = inputData.userCardModel.backgroundCover
    }
    
    override func handle(action: StudentCardFeature.Action) {
        switch action{
        case .saveTapped:
            print(action)
        case .closeTapped:
            print(action)
        case .editTapped:
            print(action)
        case .coverSelected(_):
            print(action)
        case .cancelColorSelection:
            print(action)
        case .saveColorSelection:
            print(action)
        }
    }
    private func saveAndDismiss() {
        // If onSave expects non-optional cover:
        let cover = state.selectedCover ?? .primary
        Task { @MainActor [weak self] in
            guard let self else { return }
            self.inputData.onSave(cover)
            router.navigate(to: .dismiss)
        }

     
        
    }
    
    private func fetchData() {
        
    }
}
