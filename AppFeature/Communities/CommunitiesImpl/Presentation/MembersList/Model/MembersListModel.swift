//
//  MembersListModel.swift
//  CommunitiesImpl
//
//  Created by Claude on 15.06.26.
//

import Combine
import Communities
import AppFoundation
import AppPresentationModel

// MARK: - MembersList input

struct MembersListInputData {
    let title: String
    /// Localized section heading per role, passed down from the calling module.
    let roleTitles: [AppPresentationModel.UserActivityRole: String]
    /// Server-reported total, shown in the section header instead of the loaded count.
    let totalCount: Int?
    let pageSize: Int
    let loadPage: (Int, Int, String?) async throws -> CommunitiesMemberModuleModel.MembersPage
    let onMemberTapped: (CommunitiesMemberModuleModel.MemberCellModel) -> Void
    let options: CommunitiesMemberModuleModel.MemberOptionsConfig?
}

// MARK: - Side effects

enum MembersListSideEffect: UISideEffect {
    case loading(Bool)
}

// MARK: - Feature Definition

typealias MembersListFeature = UIFeatureDefinition<
    MembersListViewState,
    MembersListAction,
    MembersListSideEffect
>

// MARK: - View State

final class MembersListViewState: UIFeatureState {
    @Published var title: String = ""
    @Published var searchText: String = ""
    @Published var sections: [MemberListSectionViewData] = []
    @Published var isLoading: Bool = false
    @Published var isLoadingMore: Bool = false
    @Published var hasMore: Bool = true
    @Published var isEmpty: Bool = false
    @Published var loadedCount: Int = 0
    @Published var pagesLoaded: Int = 0
    @Published var totalCount: Int?
    /// Bumped whenever the rows are replaced (search, reload). The view scrolls back to
    /// the top on change: a shrinking result set otherwise leaves the ScrollView parked
    /// below the new, much shorter content — the list looks blank.
    @Published var listResetToken: Int = 0
    @Published var optionsConfig: CommunitiesMemberModuleModel.MemberOptionsConfig?
}

// MARK: - Feature Action

enum MembersListAction: UIFeatureAction {
    case onAppear
    case loadMore
    case memberTapped(MemberCellViewData)
    /// Reload from the first page (e.g. after a role change).
    case reload
    /// Server-side search term changed; debounced reload from page 0.
    case searchChanged(String)
}
