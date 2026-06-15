//
//  CommunitiesMemberModuleModel.swift
//  AppFeature
//
//  Created by aplle on 3/20/26.
//

import Foundation
import AppPresentationModel

public enum CommunitiesMemberModuleModel {
    public struct MemberCellModel: Hashable, Sendable {
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
        
        public init(
            users: [MemberCellModel],
            titleOverrides: [AppPresentationModel.UserActivityRole: String] = [:]
        ) {
            let groupedUsers = Dictionary(grouping: users, by: \.role)
            let sections = groupedUsers
                .sorted { lhs, rhs in
                    lhs.key.sortPriority < rhs.key.sortPriority
                }
                .map { role, users in
                    MemberListSection(
                        title: titleOverrides[role] ?? role.title,
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
        }
    }

    var title: String {
        switch self {
        case .member:
            return "Members"
        case .president:
            return "President"
        case .visePresident:
            return "Vise president"
        case .eventCreator:
            return "Event creators"
        case .notJoined:
            return "-"
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
            onOptionsTapped: @escaping (MemberCellModel) -> Void,
            onMemberTapped: @escaping (MemberCellModel) -> Void,
            previewLimit: Int = 5,
            totalCount: Int? = nil,
            onSeeAllTapped: (() -> Void)? = nil
        ) {
            self.sections = sections
            self.onOptionsTapped = onOptionsTapped
            self.onMemberTapped = onMemberTapped
            self.previewLimit = previewLimit
            self.totalCount = totalCount
            self.onSeeAllTapped = onSeeAllTapped
        }

        public init(
            data: GroupedMembersData,
            onOptionsTapped: @escaping (MemberCellModel) -> Void,
            onMemberTapped: @escaping (MemberCellModel) -> Void,
            previewLimit: Int = 5,
            totalCount: Int? = nil,
            onSeeAllTapped: (() -> Void)? = nil
        ) {
            self.init(
                sections: data.sections,
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

        public init(members: [MemberCellModel], hasMore: Bool) {
            self.members = members
            self.hasMore = hasMore
        }
    }

    /// Input for the standalone, self-paginating members screen. The screen owns its own
    /// requests via `loadPage` (page, size) so callers never pre-fetch the full list.
    struct MembersListInput {
        public let title: String
        public let titleOverrides: [AppPresentationModel.UserActivityRole: String]
        public let pageSize: Int
        public let loadPage: (Int, Int) async throws -> MembersPage
        public let onMemberTapped: (MemberCellModel) -> Void

        public init(
            title: String,
            titleOverrides: [AppPresentationModel.UserActivityRole: String] = [:],
            pageSize: Int = 20,
            loadPage: @escaping (Int, Int) async throws -> MembersPage,
            onMemberTapped: @escaping (MemberCellModel) -> Void
        ) {
            self.title = title
            self.titleOverrides = titleOverrides
            self.pageSize = pageSize
            self.loadPage = loadPage
            self.onMemberTapped = onMemberTapped
        }
    }
}
