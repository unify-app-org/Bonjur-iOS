//
//  NeedsActionModel.swift
//  NotificationImpl
//
//  Created by Huseyn Hasanov on 28.06.26.
//

import AppFoundation
import AppUIKit
import AppNetwork
import Combine

// MARK: - Input

struct NeedsActionInputData {
}

// MARK: - Tabs

/// Top segmented control. All three are backed by live join-request list APIs;
/// `events` is read-only (no accept/reject API yet).
/// `String` raw values double as the capsule labels rendered by
/// `CapsuleSegmentedPicker` (it displays `rawValue`).
enum ActionTab: String, CaseIterable, Identifiable {
    case events = "Events"
    case hangouts = "Hangouts"
    case clubs = "Clubs"

    var id: Self { self }
}

// MARK: - Load phase

/// First-load lifecycle for a request list (drives spinner / empty / error).
enum RequestsPhase: Equatable {
    case idle
    case loading
    case loaded
    case failed
}

// MARK: - Per-source state

/// One paginated request list (clubs or hangouts). The view model owns the page
/// cursor; the view reads this for rendering.
struct RequestSourceState: Equatable {
    var items: [ActionRequestItem] = []
    var phase: RequestsPhase = .idle
    var isLoadingMore = false
    var canLoadMore = false
}

// MARK: - Side effects

enum NeedsActionSideEffect: UISideEffect {
    case error(APIError?)
    /// Ask the user to confirm before rejecting `item`.
    case confirmReject(ActionRequestItem)
}

// MARK: - Feature Definition

typealias NeedsActionFeature = UIFeatureDefinition<
    NeedsActionViewState,
    NeedsActionAction,
    NeedsActionSideEffect
>

// MARK: - View State

final class NeedsActionViewState: UIFeatureState {
    @Published var selectedTab: ActionTab = .clubs
    @Published var clubs = RequestSourceState()
    @Published var hangouts = RequestSourceState()
    @Published var events = RequestSourceState()
    /// Rows mid accept/reject — buttons disable + show a spinner.
    @Published var processingIds: Set<String> = []

    // MARK: Verification (admin-only banner)

    /// Set true only when the pending-verification probe succeeds (i.e. the
    /// `/clubs/pending` admin endpoint didn't 403). The banner gates on this.
    @Published var isAdmin = false
    /// Live pending-verification total (from the probe).
    @Published var verificationCount = 0
}

// MARK: - Feature Action

enum NeedsActionAction: UIFeatureAction {
    case onAppear
    case selectTab(ActionTab)
    case refresh(ActionTab)
    case loadMore(ActionTab)
    case retry(ActionTab)
    case accept(ActionRequestItem)
    /// User tapped Reject — triggers the confirm alert (no API call yet).
    case reject(ActionRequestItem)
    /// User confirmed rejection in the alert — performs the API call.
    case performReject(ActionRequestItem)
    /// Tapped a request cell (not the buttons) — open the requester's profile.
    case requestTapped(ActionRequestItem)
    case verificationTapped
}
