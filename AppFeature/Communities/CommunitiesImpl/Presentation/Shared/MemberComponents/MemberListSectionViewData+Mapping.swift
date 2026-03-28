//
//  MemberListSectionViewData+Mapping.swift
//  CommunitiesImpl
//
//  Created by aplle on 3/21/26.
//

import Communities

extension MemberListSectionViewData {
    static func browse(
        id: String,
        section: CommunitiesMemberModuleModel.MemberListSection
    ) -> Self {
        .init(
            id: id,
            title: section.title,
            memberCountText: section.memberCount.map { "\($0) student" },
            rows: section.members.map(MemberCellViewData.disclosure(from:)),
            showsSelectGroup: false,
            isGroupSelected: false
        )
    }
}

extension Array where Element == MemberListSectionViewData {
    static func clubMembers(
        from input: CommunitiesMemberModuleModel.ClubMembersInput
    ) -> Self {
        var sections: Self = [
            .init(
                id: "owner",
                title: "Owner",
                memberCountText: nil,
                rows: [
                    .init(
                        member: input.owner,
                        accessory: .none
                    )
                ],
                showsSelectGroup: false,
                isGroupSelected: false
            )
        ]

        if let president = input.president {
            sections.append(
                .init(
                    id: "president",
                    title: "President",
                    memberCountText: nil,
                    rows: [
                        .options(
                            from: president
                        )
                    ],
                    showsSelectGroup: false,
                    isGroupSelected: false
                )
            )
        }

        sections.append(
            .init(
                id: "members",
                title: "Members",
                memberCountText: nil,
                rows: input.members.map {
                    .options(from: $0)
                },
                showsSelectGroup: false,
                isGroupSelected: false
            )
        )

        return sections
    }
}
