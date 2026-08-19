//
//  MemberListSectionViewData+Mapping.swift
//  CommunitiesImpl
//
//  Created by aplle on 3/21/26.
//

import Communities
import AppFoundation

extension MemberListSectionViewData {
    static func browse(
        id: String,
        section: CommunitiesMemberModuleModel.MemberListSection
    ) -> Self {
        .init(
            id: id,
            title: section.title,
            memberCountText: section.memberCount.map { "count_students".localized(with: $0) },
            rows: section.members.map(MemberCellViewData.disclosure(from:)),
            showsSelectGroup: false,
            isGroupSelected: false
        )
    }

    /// Same as `browse` but rows show the 3-dot options menu instead of a disclosure.
    /// The current user's own row gets no 3-dot.
    static func browseOptions(
        id: String,
        section: CommunitiesMemberModuleModel.MemberListSection,
        currentUserId: String?
    ) -> Self {
        .init(
            id: id,
            title: section.title,
            memberCountText: section.memberCount.map { "count_students".localized(with: $0) },
            rows: section.members.map { .options(from: $0, currentUserId: currentUserId) },
            showsSelectGroup: false,
            isGroupSelected: false
        )
    }
}

extension Array where Element == MemberListSectionViewData {
    static func clubMembers(
        from input: CommunitiesMemberModuleModel.ClubMembersInput
    ) -> Self {
        input.sections.map { section in
            .init(
                id: section.title,
                title: section.title,
                memberCountText: section.memberCount.map { "\($0)" },
                rows: section.members.map {
                    .options(from: $0, currentUserId: input.currentUserId)
                },
                showsSelectGroup: false,
                isGroupSelected: false
            )
        }
    }
}
