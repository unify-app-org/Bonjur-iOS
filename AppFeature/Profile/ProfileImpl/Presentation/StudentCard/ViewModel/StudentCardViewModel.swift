// /Users/aplle/Desktop/Bonjur-iOS/AppFeature/Profile/ProfileImpl/Presentation/StudentCard/ViewModel/StudentCardViewModel.swift

import AppFoundation
import AppUIKit

final class StudentCardViewModel: UIFeatureViewModel<StudentCardFeature> {
    struct Dependencies {}

    private let router: StudentCardRouterProtocol
    private let inputData: StudentCardInputData
    private let dependencies: Dependencies

    init(
        state: StudentCardFeature.State,
        router: StudentCardRouterProtocol,
        inputData: StudentCardInputData,
        dependencies: Dependencies
    ) {
        self.router = router
        self.inputData = inputData
        self.dependencies = dependencies
        super.init(initialState: state)

        self.state.previewCard = inputData.userCardModel
        self.state.savedCover = inputData.userCardModel.backgroundCover
        self.state.draftCover = inputData.userCardModel.backgroundCover
    }

    override func handle(action: StudentCardFeature.Action) {
        switch action {
        case .closeTapped:
            handleCloseTapped()

        case .editTapped:
            handleEditTapped()

        case .setCoverSheetPresented(let isPresented):
            handleSetCoverSheetPresented(isPresented)

        case .coverSelected(let cover):
            handleCoverSelected(cover)

        case .cancelColorSelection:
            handleCancelColorSelection()

        case .saveColorSelection:
            handleSaveColorSelection()
        }
    }

    private func handleCloseTapped() {
        Task { @MainActor in
            router.navigate(to: .dismiss)
        }
    }

    private func handleEditTapped() {
        state.draftCover = state.savedCover
        state.isChooseColorSheetPresented = true
        applyPreview(cover: state.draftCover)
    }

    private func handleSetCoverSheetPresented(_ isPresented: Bool) {
        state.isChooseColorSheetPresented = isPresented

        guard !isPresented else { return }

        resetDraftToSavedCover()
    }

    private func handleCoverSelected(_ cover: AppUIEntities.BackgroundType?) {
        state.draftCover = cover
        applyPreview(cover: cover)
    }

    private func handleCancelColorSelection() {
        resetDraftToSavedCover()
        state.isChooseColorSheetPresented = false
    }

    private func handleSaveColorSelection() {
        commitDraftCover()
        state.isChooseColorSheetPresented = false
    }

    private func commitDraftCover() {
        state.savedCover = state.draftCover
        applyPreview(cover: state.savedCover)

        let committedCover = state.savedCover
        Task { @MainActor in
            inputData.onSave(committedCover)
        }
    }

    private func resetDraftToSavedCover() {
        state.draftCover = state.savedCover
        applyPreview(cover: state.savedCover)
    }

    private func applyPreview(cover: AppUIEntities.BackgroundType?) {
        guard let card = state.previewCard else { return }
        state.previewCard = card.withBackground(cover)
    }
}
