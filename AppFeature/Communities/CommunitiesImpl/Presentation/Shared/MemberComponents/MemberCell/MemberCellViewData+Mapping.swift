//
//  MemberCellViewData+Mapping.swift
//  CommunitiesImpl
//
//  Created by aplle on 3/21/26.
//


import Communities

extension MemberCellViewData {
    static func disclosure(
        from member: CommunitiesMemberModuleModel.MemberCellModel
    ) -> Self {
        .init(member: member, accessory: .disclosure)
    }

    static func selectable(
        from member: CommunitiesMemberModuleModel.MemberCellModel,
        isSelected: Bool
    ) -> Self {
        .init(member: member, accessory: .checkbox(isSelected: isSelected))
    }

    static func options(
        from member: CommunitiesMemberModuleModel.MemberCellModel
    ) -> Self {
        .init(member: member, accessory: .optionsMenu)
    }

    /// Same as `options` but hides the 3-dot on the current user's own row —
    /// you can't act on yourself, so no menu. Row stays tappable.
    static func options(
        from member: CommunitiesMemberModuleModel.MemberCellModel,
        currentUserId: String?
    ) -> Self {
        let isSelf = currentUserId.map { !$0.isEmpty && member.id == $0 } ?? false
        return .init(member: member, accessory: isSelf ? .none : .optionsMenu)
    }
}
