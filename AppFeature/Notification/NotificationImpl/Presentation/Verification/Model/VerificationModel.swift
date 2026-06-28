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
    /// Ask the user to confirm before rejecting a club's verification.
    case confirmReject(VerificationItem)
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
    /// User tapped Reject — triggers the confirm alert (no API call yet).
    case reject(VerificationItem)
    /// User confirmed rejection — performs the API call.
    case performReject(VerificationItem)
    /// Tapped a verification cell (not the buttons) — open the club detail.
    case cellTapped(VerificationItem)
}
