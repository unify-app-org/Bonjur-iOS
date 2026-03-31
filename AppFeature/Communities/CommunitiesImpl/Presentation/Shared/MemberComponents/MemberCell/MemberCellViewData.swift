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

    init(
        member: CommunitiesMemberModuleModel.MemberCellModel,
        accessory: MemberCellAccessory
    ) {
        self.id = member.id
        self.member = member
        self.accessory = accessory
    }
}
