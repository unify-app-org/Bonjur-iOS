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
    /// First-load lifecycle (spinner / empty / error). Reuses the NeedsAction phase enum.
    @Published var phase: RequestsPhase = .idle
    @Published var isLoadingMore = false
    @Published var canLoadMore = false
}

// MARK: - Feature Action

enum NotificationAction: UIFeatureAction {
    case fetchData
    case retry
    case loadMore
    case markAllRead
    case actionBannerTapped
    /// Opens the modal preview for a feed row.
    case itemTapped(id: String)
}
