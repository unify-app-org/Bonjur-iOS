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
