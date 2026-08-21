//
//  VerificationModel.swift
//  NotificationImpl
//
//  Created by Huseyn Hasanov on 28.06.26.
//

import AppFoundation
import AppUIKit
import AppNetwork
import Combine

// MARK: - Input

struct VerificationInputData {
}

// MARK: - Side effects

enum VerificationSideEffect: UISideEffect {
    case error(APIError?)
}

// MARK: - Feature Definition

typealias VerificationFeature = UIFeatureDefinition<
    VerificationViewState,
    VerificationAction,
    VerificationSideEffect
>

// MARK: - View State

final class VerificationViewState: UIFeatureState {
    @Published var items: [VerificationItem] = []
    @Published var phase: RequestsPhase = .idle
    @Published var isLoadingMore = false
    @Published var canLoadMore = false
    /// Rows mid verify/reject — buttons disable + show a spinner.
    @Published var processingIds: Set<String> = []
}

// MARK: - Feature Action

enum VerificationAction: UIFeatureAction {
    case onAppear
    case refresh
    case loadMore
    case retry
    case verify(VerificationItem)
    /// User confirmed the rejection in the note sheet — performs the API call.
    /// `note` is the optional reason shown to the club; nil when left blank.
    case performReject(item: VerificationItem, note: String?)
    /// Tapped a verification cell (not the buttons) — open the club detail.
    case cellTapped(VerificationItem)
}
