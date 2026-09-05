//
//  CommunitiesMemberModuleModel.swift
//  AppFeature
//
//  Created by aplle on 3/20/26.
//

import Foundation
import AppPresentationModel

public enum CommunitiesMemberModuleModel {

    /// Input for the shared member 3-dot options sheet (Change role / Report / Share).
    /// The sheet is pure UI: the caller computes visibility via
    /// `AppPresentationModel.MemberOptionsPolicy` and supplies the network work
    /// through the async callbacks (which return `true` on success).
    public struct MemberOptionsInput {
        public let memberName: String
        public let currentRole: AppPresentationModel.UserActivityRole
        /// Roles selectable in the picker, already filtered for the viewer.
        public let assignableRoles: [AppPresentationModel.UserActivityRole]
        /// Whether to show the "Change role" row.
        public let showChangeRole: Bool
        /// Whether to show the "Report user" row.
        public let showReport: Bool
        /// Performs the role change. Returns `true` when it succeeded so the
        /// sheet can dismiss; `false` keeps the picker open.
        public let onAssignRole: (AppPresentationModel.UserActivityRole) async -> Bool
        /// Submits a report. Returns `true` on success.
        public let onReport: (AppPresentationModel.ReportReason) async -> Bool

        public init(
            memberName: String,
            currentRole: AppPresentationModel.UserActivityRole,
            assignableRoles: [AppPresentationModel.UserActivityRole],
            showChangeRole: Bool,
            showReport: Bool,
            onAssignRole: @escaping (AppPresentationModel.UserActivityRole) async -> Bool,
            onReport: @escaping (AppPresentationModel.ReportReason) async -> Bool
        ) {
            self.memberName = memberName
            self.currentRole = currentRole
            self.assignableRoles = assignableRoles
            self.showChangeRole = showChangeRole
            self.showReport = showReport
            self.onAssignRole = onAssignRole
            self.onReport = onReport
        }
    }

    public struct MemberCellModel: Hashable, Sendable, Identifiable {
        public let id: String
        public let name: String
        public let avatarURL: URL?
        public let subtitle: String
        public let role: AppPresentationModel.UserActivityRole

        public init(
            id: String,
            name: String,
            avatarURL: URL?,
            subtitle: String,
            role: AppPresentationModel.UserActivityRole = .member
        ) {
            self.id = id
            self.name = name
            self.avatarURL = avatarURL
            self.subtitle = subtitle
            self.role = role
        }
    }

    public struct MemberListSection: Hashable, Sendable {
        public let title: String
        public let memberCount: Int?
        public let members: [MemberCellModel]

        public init(title: String, memberCount: Int? = nil, members: [MemberCellModel]) {
            self.title = title
            self.memberCount = memberCount
            self.members = members
        }
    }

    public struct GroupedMembersData: Hashable, Sendable {
        public let sections: [MemberListSection]

        public init(sections: [MemberListSection]) {
            self.sections = sections
        }
        
        /// `roleTitles` supplies the section heading for every role. This module is
        /// deliberately dependency-free (no localization), so the titles are localized
        /// by the caller — see `UserActivityRole.localizedTitles(overriding:)` in
        /// AppUIKit. A role missing from the map falls back to its raw value, which is
        /// a diagnostic string, not something meant to reach the UI.
        public init(
            users: [MemberCellModel],
            roleTitles: [AppPresentationModel.UserActivityRole: String]
        ) {
            // Every row here is an accepted member, so a role that does not describe one
            // — `.notJoined` (which is also where an unrecognised server value lands) or
            // `.requested` — means "rank unknown", not "not a member". Both carry the
            // title "-", which is what reached the screen as a section headed with a dash.
            let groupedUsers = Dictionary(grouping: users) { user in
                switch user.role {
                case .notJoined, .requested:
                    return AppPresentationModel.UserActivityRole.member
                default:
                    return user.role
                }
            }
            let sections = groupedUsers
                .sorted { lhs, rhs in
                    lhs.key.sortPriority < rhs.key.sortPriority
                }
                .map { role, users in
                    MemberListSection(
                        title: roleTitles[role] ?? role.rawValue,
                        memberCount: users.count,
                        members: users.sorted { lhs, rhs in
                            lhs.name.localizedCaseInsensitiveCompare(rhs.name) == .orderedAscending
                        }
                    )
                }

            self.sections = sections
        }
    }

    public struct FacultyRowModel: Hashable, Sendable {
        public let id: String
        public let title: String
        public let studentListTitle: String?
        public let sections: [MemberListSection]

        public init(
            id: String,
            title: String,
            studentListTitle: String? = nil,
            sections: [MemberListSection]
        ) {
            self.id = id
            self.title = title
            self.studentListTitle = studentListTitle
            self.sections = sections
        }

        public init(
            id: String,
            title: String
        ) {
            self.init(
                id: id,
                title: title,
                studentListTitle: nil,
                sections: []
            )
        }
    }
}

private extension AppPresentationModel.UserActivityRole {
    var sortPriority: Int {
        switch self {
        case .president:
            return 0
        case .visePresident:
            return 1
        case .eventCreator:
            return 2
        case .member:
            return 3
        case .notJoined:
            return 4
        case .requested:
            return 5
        }
    }
}

public extension CommunitiesMemberModuleModel {
    struct FacultySelectionMembersInput {
        public let title: String
        public let sectionTitle: String
        public let faculties: [FacultyRowModel]
        public let capacityLimit: Int?
        public let onNext: ([MemberCellModel]) -> Void
        public let onSkip: () -> Void

        public init(
            title: String,
            sectionTitle: String = "Faculty",
            faculties: [FacultyRowModel],
            capacityLimit: Int? = nil,
            onNext: @escaping ([MemberCellModel]) -> Void,
            onSkip: @escaping () -> Void
        ) {
            self.title = title
            self.sectionTitle = sectionTitle
            self.faculties = faculties
            self.capacityLimit = capacityLimit
            self.onNext = onNext
            self.onSkip = onSkip
        }
    }

    struct FacultySelectionFacultiesInput {
        public let title: String
        public let sectionTitle: String
        public let faculties: [FacultyRowModel]
        public let onNext: ([FacultyRowModel]) -> Void
        public let onSkip: () -> Void

        public init(
            title: String,
            sectionTitle: String = "Faculty",
            faculties: [FacultyRowModel],
            onNext: @escaping ([FacultyRowModel]) -> Void,
            onSkip: @escaping () -> Void
        ) {
            self.title = title
            self.sectionTitle = sectionTitle
            self.faculties = faculties
            self.onNext = onNext
            self.onSkip = onSkip
        }
    }

    struct FacultyBrowseStudentsInput {
        public let title: String
        public let sectionTitle: String
        public let faculties: [FacultyRowModel]
        public let onMemberTapped: (MemberCellModel) -> Void

        public init(
            title: String,
            sectionTitle: String = "Faculty",
            faculties: [FacultyRowModel],
            onMemberTapped: @escaping (MemberCellModel) -> Void
        ) {
            self.title = title
            self.sectionTitle = sectionTitle
            self.faculties = faculties
            self.onMemberTapped = onMemberTapped
        }
    }

    struct FacultyBrowseFacultiesInput {
        public let title: String
        public let sectionTitle: String
        public let faculties: [FacultyRowModel]
        public let onFacultyTapped: (FacultyRowModel) -> Void

        public init(
            title: String,
            sectionTitle: String = "Faculty",
            faculties: [FacultyRowModel],
            onFacultyTapped: @escaping (FacultyRowModel) -> Void
        ) {
            self.title = title
            self.sectionTitle = sectionTitle
            self.faculties = faculties
            self.onFacultyTapped = onFacultyTapped
        }
    }

    struct FacultyStudentListViewInput {
        public let title: String
        public let sections: [MemberListSection]
        public let onMemberTapped: (MemberCellModel) -> Void

        public init(
            title: String,
            sections: [MemberListSection],
            onMemberTapped: @escaping (MemberCellModel) -> Void
        ) {
            self.title = title
            self.sections = sections
            self.onMemberTapped = onMemberTapped
        }
    }

    struct FacultyStudentListSelectInput {
        public let title: String
        public let sections: [MemberListSection]
        public let initiallySelectedMembers: [MemberCellModel]
        public let onSelectionConfirmed: ([MemberCellModel]) -> Void

        public init(
            title: String,
            sections: [MemberListSection],
            initiallySelectedMembers: [MemberCellModel] = [],
            onSelectionConfirmed: @escaping ([MemberCellModel]) -> Void
        ) {
            self.title = title
            self.sections = sections
            self.initiallySelectedMembers = initiallySelectedMembers
            self.onSelectionConfirmed = onSelectionConfirmed
        }
    }

    struct ClubMembersInput {
        public let sections: [MemberListSection]
        /// Current user id, so the embedded list can hide the 3-dot on your own row.
        public let currentUserId: String?
        public let onOptionsTapped: (MemberCellModel) -> Void
        public let onMemberTapped: (MemberCellModel) -> Void
        /// When set, the embedded list renders at most this many member rows (by role order)
        /// and shows a "See all" affordance once the total exceeds the limit.
        public let previewLimit: Int
        /// Total member count used for the "See all (N)" label and the preview threshold.
        /// Falls back to the loaded row count when `nil`.
        public let totalCount: Int?
        /// Called when the "See all" affordance is tapped. `nil` hides the affordance.
        public let onSeeAllTapped: (() -> Void)?

        public init(
            sections: [MemberListSection],
            currentUserId: String? = nil,
            onOptionsTapped: @escaping (MemberCellModel) -> Void,
            onMemberTapped: @escaping (MemberCellModel) -> Void,
            previewLimit: Int = 5,
            totalCount: Int? = nil,
            onSeeAllTapped: (() -> Void)? = nil
        ) {
            self.sections = sections
            self.currentUserId = currentUserId
            self.onOptionsTapped = onOptionsTapped
            self.onMemberTapped = onMemberTapped
            self.previewLimit = previewLimit
            self.totalCount = totalCount
            self.onSeeAllTapped = onSeeAllTapped
        }

        public init(
            data: GroupedMembersData,
            currentUserId: String? = nil,
            onOptionsTapped: @escaping (MemberCellModel) -> Void,
            onMemberTapped: @escaping (MemberCellModel) -> Void,
            previewLimit: Int = 5,
            totalCount: Int? = nil,
            onSeeAllTapped: (() -> Void)? = nil
        ) {
            self.init(
                sections: data.sections,
                currentUserId: currentUserId,
                onOptionsTapped: onOptionsTapped,
                onMemberTapped: onMemberTapped,
                previewLimit: previewLimit,
                totalCount: totalCount,
                onSeeAllTapped: onSeeAllTapped
            )
        }
    }

    /// One page of members plus whether more pages remain. Returned by a `MembersListInput`
    /// page provider so the paginated members screen can drive infinite scroll.
    struct MembersPage: Sendable {
        public let members: [MemberCellModel]
        public let hasMore: Bool
        /// Total rows the query matches (`totalElements`). Comes from the same
        /// response as the page, so it also reflects an active keyword filter —
        /// unlike a total handed in by the caller from a detail payload.
        public let totalCount: Int?

        public init(members: [MemberCellModel], hasMore: Bool, totalCount: Int? = nil) {
            self.members = members
            self.hasMore = hasMore
            self.totalCount = totalCount
        }
    }

    /// Enables the 3-dot member options menu on a members list. Carries everything
    /// the shared options sheet needs that the list itself can't compute: the
    /// viewer's role, the activity kind, the current user id (for the self-check),
    /// and the async network callbacks. When `nil`, rows are plain (no menu).
    public struct MemberOptionsConfig {
        public let viewerRole: AppPresentationModel.UserActivityRole
        public let activity: AppPresentationModel.ActivityType
        public let currentUserId: String
        public let onAssignRole: (String, AppPresentationModel.UserActivityRole) async -> Bool
        public let onReport: (String, AppPresentationModel.ReportReason) async -> Bool

        public init(
            viewerRole: AppPresentationModel.UserActivityRole,
            activity: AppPresentationModel.ActivityType,
            currentUserId: String,
            onAssignRole: @escaping (String, AppPresentationModel.UserActivityRole) async -> Bool,
            onReport: @escaping (String, AppPresentationModel.ReportReason) async -> Bool
        ) {
            self.viewerRole = viewerRole
            self.activity = activity
            self.currentUserId = currentUserId
            self.onAssignRole = onAssignRole
            self.onReport = onReport
        }
    }

    /// Input for the standalone, self-paginating members screen. The screen owns its own
    /// requests via `loadPage` (page, size, keyword) so callers never pre-fetch the full list.
    /// `keyword` is the server-side member search term (nil/empty = unfiltered).
    struct MembersListInput {
        public let title: String
        /// Localized section heading per role, supplied by the caller (this module
        /// resolves no strings of its own).
        public let roleTitles: [AppPresentationModel.UserActivityRole: String]
        /// Total members on the server, when the caller knows it (e.g. from the
        /// detail payload). The section header shows this rather than the number of
        /// rows paged in so far.
        public let totalCount: Int?
        public let pageSize: Int
        public let loadPage: (Int, Int, String?) async throws -> MembersPage
        public let onMemberTapped: (MemberCellModel) -> Void
        /// When set, rows show the 3-dot options menu backed by this config.
        public let options: MemberOptionsConfig?

        public init(
            title: String,
            roleTitles: [AppPresentationModel.UserActivityRole: String],
            totalCount: Int? = nil,
            pageSize: Int = 20,
            loadPage: @escaping (Int, Int, String?) async throws -> MembersPage,
            onMemberTapped: @escaping (MemberCellModel) -> Void,
            options: MemberOptionsConfig? = nil
        ) {
            self.title = title
            self.roleTitles = roleTitles
            self.totalCount = totalCount
            self.pageSize = pageSize
            self.loadPage = loadPage
            self.onMemberTapped = onMemberTapped
            self.options = options
        }
    }
}
