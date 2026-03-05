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

    // Committed value
    @Published var selectedCover: AppUIEntities.BackgroundType?

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
}

enum StudentCardAction: UIFeatureAction {
    case saveTapped
    case closeTapped
    case editTapped
    case setCoverSheetPresented(Bool)
    case coverSelected(AppUIEntities.BackgroundType?)
    case cancelColorSelection
    case saveColorSelection
    case coverSheetDismissed
}
