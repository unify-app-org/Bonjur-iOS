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
            state.isChooseColorSheetPresented = isPresented

        case .coverSelected(let cover):
            handleCoverSelected(cover)

        case .cancelColorSelection:
            handleCancelColorSelection()

        case .saveColorSelection:
            handleSaveColorSelection()

        case .coverSheetDismissed:
            handleCoverSheetDismissed()
        }
    }

    private func handleCloseTapped() {
        let committedCover = state.savedCover
        Task { @MainActor in
            inputData.onSave(committedCover)
            router.navigate(to: .dismiss)
        }
    }

    private func handleEditTapped() {
        state.draftCover = state.savedCover
        state.coverSheetDismissIntent = .none
        state.isChooseColorSheetPresented = true
        applyPreview(cover: state.draftCover)
    }

    private func handleCoverSelected(_ cover: AppUIEntities.BackgroundType?) {
        state.draftCover = cover
        applyPreview(cover: cover)
    }

    private func handleCancelColorSelection() {
        state.coverSheetDismissIntent = .cancel
        state.draftCover = state.savedCover
        applyPreview(cover: state.savedCover)
        state.isChooseColorSheetPresented = false
    }

    private func handleSaveColorSelection() {
        state.coverSheetDismissIntent = .save
        commitDraftCover(resetDismissIntent: false)
        state.isChooseColorSheetPresented = false
    }

    private func handleCoverSheetDismissed() {
        state.isChooseColorSheetPresented = false

        switch state.coverSheetDismissIntent {
        case .cancel:
            state.coverSheetDismissIntent = .none
        case .save:
            state.coverSheetDismissIntent = .none
        case .none:
            commitDraftCover()
        }
    }

    private func commitDraftCover(resetDismissIntent: Bool = true) {
        state.savedCover = state.draftCover
        applyPreview(cover: state.savedCover)

        if resetDismissIntent {
            state.coverSheetDismissIntent = .none
        }

        let committedCover = state.savedCover
        Task { @MainActor in
            inputData.onSave(committedCover)
        }
    }

    private func applyPreview(cover: AppUIEntities.BackgroundType?) {
        guard let card = state.previewCard else { return }
        state.previewCard = card.withBackground(cover)
    }
}
