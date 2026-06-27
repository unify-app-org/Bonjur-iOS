//
//  NotificationModel.swift
//  NotificationImpl
//
//  Created by Huseyn Hasanov on 27.06.26.
//

import AppFoundation
import AppUIKit
import AppNetwork
import Combine

// MARK: - Input

struct NotificationInputData {
}

// MARK: - Side effects

enum NotificationSideEffect: UISideEffect {
    case loading(Bool)
    case error(APIError?)
}

// MARK: - Feature Definition

typealias NotificationFeature = UIFeatureDefinition<
    NotificationViewState,
    NotificationAction,
    NotificationSideEffect
>

// MARK: - View State

final class NotificationViewState: UIFeatureState {
    @Published var uiModel: NotificationInbox = .empty
}

// MARK: - Feature Action

enum NotificationAction: UIFeatureAction {
    case fetchData
    case markAllRead
    /// Banner is static for now — tap is a no-op until the action screen exists.
    case actionBannerTapped
    /// Rows don't deep-link yet — placeholder for the next pass.
    case itemTapped(id: String)
}
