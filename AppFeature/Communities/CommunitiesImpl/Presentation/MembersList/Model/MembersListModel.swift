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
    let titleOverrides: [AppPresentationModel.UserActivityRole: String]
    let pageSize: Int
    let loadPage: (Int, Int) async throws -> CommunitiesMemberModuleModel.MembersPage
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
    @Published var sections: [MemberListSectionViewData] = []
    @Published var isLoading: Bool = false
    @Published var isLoadingMore: Bool = false
    @Published var hasMore: Bool = true
    @Published var isEmpty: Bool = false
    /// Non-nil when the 3-dot options menu is enabled for this list.
    @Published var optionsConfig: CommunitiesMemberModuleModel.MemberOptionsConfig?
}

// MARK: - Feature Action

enum MembersListAction: UIFeatureAction {
    case onAppear
    case loadMore
    case memberTapped(MemberCellViewData)
    /// Reload from the first page (e.g. after a role change).
    case reload
}
