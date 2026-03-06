// /Users/aplle/Desktop/Bonjur-iOS/AppFeature/Profile/ProfileImpl/Presentation/StudentCard/Model/StudentCardModel.swift

import AppFoundation
import AppUIKit
import SwiftUI

struct StudentCardInputData {
    let userCardModel: UserCardModel
    let onSave: @MainActor (AppUIEntities.BackgroundType?) -> Void
}

enum StudentCardSideEffect: UISideEffect {
    case loading(Bool)
}

typealias StudentCardFeature = UIFeatureDefinition<
    StudentCardViewState,
    StudentCardAction,
    StudentCardSideEffect
>

final class StudentCardViewState: UIFeatureState {
    enum CoverSheetDismissIntent {
        case none
        case cancel
        case save
    }

    @Published var previewCard: UserCardModel?

    // Mirrored committed value
    @Published var savedCover: AppUIEntities.BackgroundType?

    // Draft value while sheet is open
    @Published var draftCover: AppUIEntities.BackgroundType?

    @Published var isChooseColorSheetPresented: Bool = false
    @Published var coverSheetDismissIntent: CoverSheetDismissIntent = .none
    @Published var isSaving: Bool = false

    static let availableCovers: [AppUIEntities.BackgroundType?] = [
        nil,
        .primary,
        .secondary,
        .teritary,
        .color(.orange),
        .color(.red),
        .color(.pink)
    ]

    var displayedCover: AppUIEntities.BackgroundType? {
        isChooseColorSheetPresented ? draftCover : savedCover
    }

    var selectedColor: Color {
        displayedCover?.bgColor ?? Color.Palette.white
    }

    var shouldShowCollapsedSpacing: Bool {
        !isChooseColorSheetPresented
    }

    var coverSheetDetents: Set<PresentationDetent> {
        [.fraction(0.4)]
    }

    func coverSheetBinding(
        onSetCoverSheetPresented: @escaping (Bool) -> Void
    ) -> Binding<Bool> {
        Binding(
            get: { [weak self] in
                self?.isChooseColorSheetPresented ?? false
            },
            set: { isPresented in
                if isPresented {
                    onSetCoverSheetPresented(true)
                }
            }
        )
    }

    func draftCoverBinding(
        onCoverSelected: @escaping (AppUIEntities.BackgroundType?) -> Void
    ) -> Binding<AppUIEntities.BackgroundType?> {
        Binding(
            get: { [weak self] in
                self?.draftCover
            },
            set: { [weak self] cover in
                guard let self, self.isChooseColorSheetPresented else { return }
                onCoverSelected(cover)
            }
        )
    }
}

enum StudentCardAction: UIFeatureAction {
    case closeTapped
    case editTapped
    case setCoverSheetPresented(Bool)
    case coverSelected(AppUIEntities.BackgroundType?)
    case cancelColorSelection
    case saveColorSelection
    case coverSheetDismissed
}
