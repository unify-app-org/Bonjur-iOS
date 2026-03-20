//
//  CommunitiesMemberModuleModel.swift
//  AppFeature
//
//  Created by aplle on 3/20/26.
//


import Foundation

public enum CommunitiesMemberModuleModel {
    public struct MemberCellModel: Hashable, Sendable {
        public let id: String
        public let name: String
        public let avatarURL: URL?
        public let subtitle: String

        public init(id: String, name: String, avatarURL: URL?, subtitle: String) {
            self.id = id
            self.name = name
            self.avatarURL = avatarURL
            self.subtitle = subtitle
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

    public struct FacultyRowModel: Hashable, Sendable {
        public let id: String
        public let label: String

        public init(id: String, label: String) {
            self.id = id
            self.label = label
        }
    }
}


public extension CommunitiesMemberModuleModel {
    struct MemberSelectionInput {
        public let title: String
        public let sections: [MemberListSection]
        public let capacityLimit: Int?
        public let onNext: ([MemberCellModel]) -> Void
        public let onSkip: () -> Void
    }

    struct MemberBrowseInput {
        public let title: String
        public let faculties: [FacultyRowModel]
        public let onFacultyTapped: (FacultyRowModel) -> Void
    }

    struct FacultyStudentListViewInput {
        public let title: String
        public let facultyOptions: [String]
        public let sections: [MemberListSection]
        public let onMemberTapped: (MemberCellModel) -> Void
    }

    struct FacultyStudentListSelectInput {
        public let title: String
        public let facultyOptions: [String]
        public let sections: [MemberListSection]
        public let capacityLimit: Int?
        public let onSelectionConfirmed: ([MemberCellModel]) -> Void
        public let onSkip: () -> Void
    }

    struct ClubMembersInput {
        public let owner: MemberCellModel
        public let president: MemberCellModel?
        public let members: [MemberCellModel]
        public let onOptionsTapped: (MemberCellModel) -> Void
        public let onJoinTapped: (() -> Void)?
    }
}
