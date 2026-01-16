//
//  DiscoveryModel.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 16.01.26.
//

import Foundation
import AppUIKit

// MARK: - DiscoveryModel
struct DiscoveryModel {
    let user: UserModel
    let filters: [FilterView.Model]
    let communities: [CommunityCardView.Model]
    let clubs: [ClubCardView.Model]
    let events: [EventsCardView.Model]
    let hangouts: [HangoutsCardView.Model]
}

// MARK: - User
struct UserModel {
    let id: Int
    let name: String
    let profileImage: String?
    let greeting: String
}
