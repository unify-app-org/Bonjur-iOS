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
        self.state.selectedCover = inputData.userCardModel.backgroundCover
    }

    override func handle(action: StudentCardFeature.Action) {
        switch action {
        case .saveTapped:
            break

        case .closeTapped:
            Task { @MainActor in
                router.navigate(to: .dismiss)
            }

        case .editTapped:
            state.draftCover = state.savedCover
            state.coverSheetDismissIntent = .none
            state.isChooseColorSheetPresented = true
            applyPreview(cover: state.draftCover)

        case .setCoverSheetPresented(let isPresented):
            state.isChooseColorSheetPresented = isPresented

        case .coverSelected(let cover):
            state.draftCover = cover
            applyPreview(cover: cover)

        case .cancelColorSelection:
            state.coverSheetDismissIntent = .cancel
            state.draftCover = state.savedCover
            state.selectedCover = state.savedCover
            applyPreview(cover: state.savedCover)
            state.isChooseColorSheetPresented = false

        case .saveColorSelection:
            state.coverSheetDismissIntent = .save
            commitDraftCover(resetDismissIntent: false)
            state.isChooseColorSheetPresented = false

        case .coverSheetDismissed:
            handleCoverSheetDismissed()
        }
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
        state.selectedCover = state.draftCover
        state.savedCover = state.draftCover
        applyPreview(cover: state.selectedCover)

        if resetDismissIntent {
            state.coverSheetDismissIntent = .none
        }

        Task { @MainActor [weak self] in
            guard let self else { return }
            self.inputData.onSave(self.state.selectedCover)
        }
    }

    private func applyPreview(cover: AppUIEntities.BackgroundType?) {
        guard let card = state.previewCard else { return }
        state.previewCard = card.withBackground(cover)
    }
}
