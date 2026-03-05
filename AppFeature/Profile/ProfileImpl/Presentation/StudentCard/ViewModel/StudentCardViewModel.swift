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
            Task { @MainActor in
                        router.navigate(to: .dismiss)
                   }
        case .editTapped:
            
            state.draftCover = state.selectedCover
               state.isChooseColorSheetPresented = true

        case .coverSelected(let cover):
            state.draftCover = cover
        case .cancelColorSelection:
            state.isChooseColorSheetPresented = false
                state.draftCover = state.selectedCover
        case .saveColorSelection:
            state.selectedCover = state.draftCover
                if let card = state.previewCard {
                    state.previewCard = card.withBackground(state.selectedCover)
                }
                state.isChooseColorSheetPresented = false
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
