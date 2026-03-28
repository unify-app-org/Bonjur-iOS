//
//  MemberListSectionViewData.swift
//  AppFeature
//
//  Created by aplle on 3/21/26.
//

import Foundation
struct MemberListSectionViewData: Identifiable, Hashable {
    let id: String
    let title: String
    let memberCountText: String?
    let rows: [MemberCellViewData]
    let showsSelectGroup: Bool
    let isGroupSelected: Bool
}
