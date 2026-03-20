//
//  MemberCellViewData.swift
//  AppFeature
//
//  Created by aplle on 3/20/26.
//


import Communities

struct MemberCellViewData: Identifiable, Hashable {
    let id: String
    let member: CommunitiesMemberModuleModel.MemberCellModel
    let accessory: MemberCellAccessory
    let roleTitle: String?

    init(
        member: CommunitiesMemberModuleModel.MemberCellModel,
        accessory: MemberCellAccessory,
        roleTitle: String? = nil
    ) {
        self.id = member.id
        self.member = member
        self.accessory = accessory
        self.roleTitle = roleTitle
    }
}
