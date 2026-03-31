//
//  CommunitiesMemberModuleModel+EventDetails.swift
//  AppFeature
//
//  Created by Codex on 31.03.26.
//

import Communities

extension CommunitiesMemberModuleModel.ClubMembersInput {
    init(
        from membersData: EventsDetailsModel.MembersData,
        onOptionsTapped: @escaping (CommunitiesMemberModuleModel.MemberCellModel) -> Void = { _ in },
        onMemberTapped: @escaping (CommunitiesMemberModuleModel.MemberCellModel) -> Void = { _ in }
    ) {
        self.init(
            owner: .init(from: membersData.owner),
            president: membersData.president.map(CommunitiesMemberModuleModel.MemberCellModel.init(from:)),
            members: membersData.members.map(CommunitiesMemberModuleModel.MemberCellModel.init(from:)),
            onOptionsTapped: onOptionsTapped,
            onMemberTapped: onMemberTapped
        )
    }
}

private extension CommunitiesMemberModuleModel.MemberCellModel {
    init(from member: EventsDetailsModel.Member) {
        self.init(
            id: member.id,
            name: member.name,
            avatarURL: member.avatarURL,
            subtitle: member.subtitle
        )
    }
}
