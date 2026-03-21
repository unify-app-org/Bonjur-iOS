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
        from member: CommunitiesMemberModuleModel.MemberCellModel,
        roleTitle: String? = nil
    ) -> Self {
        .init(member: member, accessory: .optionsMenu, roleTitle: roleTitle)
    }
}
