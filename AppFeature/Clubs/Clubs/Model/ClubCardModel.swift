//
//  ClubCardModel.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 17.01.26.
//

import Foundation
import AppUIKit

public struct ClubCardModel {
    
    struct Model: Identifiable {
        public let uuid: UUID = UUID()
        public let id: Int
        let name, communityName: String
        let logoURL: String
        let memberCount, totalCapacity: Int
        let community: String
        public let type: AppUIEntities.ActivityType = .clubs
        let members: [AppUIEntities.Member]
        let bgType: AppUIEntities.BackgroundType
        let accessType: AppUIEntities.AccessType
        let requestType: AppUIEntities.RequestType
        
        public init(
            id: Int,
            name: String,
            communityName: String,
            logoURL: String,
            memberCount: Int,
            totalCapacity: Int,
            community: String,
            members: [AppUIEntities.Member],
            bgType: AppUIEntities.BackgroundType,
            accessType: AppUIEntities.AccessType,
            requestType: AppUIEntities.RequestType,
        ) {
            self.id = id
            self.name = name
            self.communityName = communityName
            self.logoURL = logoURL
            self.memberCount = memberCount
            self.totalCapacity = totalCapacity
            self.members = members
            self.bgType = bgType
            self.accessType = accessType
            self.requestType = requestType
            self.community = community
        }
    }
}
