//
//  StudentCardModel.swift
//  ProfileImpl
//
//  Created by aplle on 3/4/26.
//

import AppFoundation
import AppUIKit
import SwiftUI
// MARK: - StudentCard input

struct StudentCardInputData {
    let userCardModel: UserCardModel
    let onSave: @MainActor (AppUIEntities.BackgroundType?) -> Void
}

// MARK: - Side effects

enum StudentCardSideEffect: UISideEffect {
    case loading(Bool)
}

// MARK: - Feature Definition

typealias StudentCardFeature = UIFeatureDefinition<
    StudentCardViewState,
    StudentCardAction,
    StudentCardSideEffect
>

// MARK: - View State

final class StudentCardViewState: UIFeatureState {
    // Card data shown in preview
    @Published var previewCard: UserCardModel?
    
    // Current edited selection in this screen
    @Published var selectedCover: AppUIEntities.BackgroundType?
    
    
    // Last committed value
    @Published var savedCover: AppUIEntities.BackgroundType?
    
    // Last committed value
    @Published var draftCover: AppUIEntities.BackgroundType?

    // UI state
    @Published var isChooseColorSheetPresented: Bool = false
    @Published var isSaving: Bool = false
    
   // palette for picker
   static let availableCovers: [AppUIEntities.BackgroundType] = [
           .primary, .secondary, .teritary, .color(.orange), .color(.red), .color(.pink)
       ]
}

// MARK: - Feature Action

enum StudentCardAction: UIFeatureAction {
    case saveTapped,closeTapped,editTapped,coverSelected(AppUIEntities.BackgroundType?),cancelColorSelection,saveColorSelection
}
