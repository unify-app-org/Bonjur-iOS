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
            onMemberTapped: @escaping (MemberCellModel) -> Void
        ) {
            self.owner = owner
            self.president = president
            self.members = members
            self.onOptionsTapped = onOptionsTapped
            self.onMemberTapped = onMemberTapped
        }
    }
}
