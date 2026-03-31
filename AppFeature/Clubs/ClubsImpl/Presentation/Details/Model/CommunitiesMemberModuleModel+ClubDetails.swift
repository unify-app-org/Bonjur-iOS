//
//  CommunitiesMemberModuleModel+ClubDetails.swift
//  AppFeature
//
//  Created by Codex on 31.03.26.
//

import Communities

extension CommunitiesMemberModuleModel.ClubMembersInput {
    init(
        from clubMembers: ClubsDetailsModel.ClubMembers,
        onOptionsTapped: @escaping (CommunitiesMemberModuleModel.MemberCellModel) -> Void = { _ in },
        onMemberTapped: @escaping (CommunitiesMemberModuleModel.MemberCellModel) -> Void = { _ in }
    ) {
        self.init(
            owner: .init(from: clubMembers.owner),
            president: clubMembers.president.map(CommunitiesMemberModuleModel.MemberCellModel.init(from:)),
            members: clubMembers.members.map(CommunitiesMemberModuleModel.MemberCellModel.init(from:)),
            onOptionsTapped: onOptionsTapped,
            onMemberTapped: onMemberTapped
        )
    }
}

private extension CommunitiesMemberModuleModel.MemberCellModel {
    init(from member: ClubsDetailsModel.Member) {
        self.init(
            id: member.id,
            name: member.name,
            avatarURL: member.avatarURL,
            subtitle: member.subtitle
        )
    }
}
