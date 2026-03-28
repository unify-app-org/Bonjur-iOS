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
    struct FacultySelectionInput {
        public let title: String
        public let sectionTitle: String
        public let sections: [MemberListSection]
        public let capacityLimit: Int?
        public let onNext: ([MemberCellModel]) -> Void
        public let onSkip: () -> Void

        public init(
            title: String,
            sectionTitle: String = "Faculty",
            sections: [MemberListSection],
            capacityLimit: Int? = nil,
            onNext: @escaping ([MemberCellModel]) -> Void,
            onSkip: @escaping () -> Void
        ) {
            self.title = title
            self.sectionTitle = sectionTitle
            self.sections = sections
            self.capacityLimit = capacityLimit
            self.onNext = onNext
            self.onSkip = onSkip
        }
    }

    struct FacultyBrowseInput {
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
        public let capacityLimit: Int?
        public let onSelectionConfirmed: ([MemberCellModel]) -> Void
        public let onSkip: () -> Void

        public init(
            title: String,
            sections: [MemberListSection],
            capacityLimit: Int? = nil,
            onSelectionConfirmed: @escaping ([MemberCellModel]) -> Void,
            onSkip: @escaping () -> Void
        ) {
            self.title = title
            self.sections = sections
            self.capacityLimit = capacityLimit
            self.onSelectionConfirmed = onSelectionConfirmed
            self.onSkip = onSkip
        }
    }

    struct ClubMembersInput {
        public let owner: MemberCellModel
        public let president: MemberCellModel?
        public let members: [MemberCellModel]
        public let onOptionsTapped: (MemberCellModel) -> Void
        public let onMemberTapped: (MemberCellModel) -> Void

        public init(
            owner: MemberCellModel,
            president: MemberCellModel? = nil,
            members: [MemberCellModel],
            onOptionsTapped: @escaping (MemberCellModel) -> Void,
            onMemberTapped:@escaping (MemberCellModel) -> Void
        ) {
            self.owner = owner
            self.president = president
            self.members = members
            self.onOptionsTapped = onOptionsTapped
            self.onMemberTapped = onMemberTapped
        }
    }
}
