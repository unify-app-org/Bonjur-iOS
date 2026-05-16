//
//  CommunityDTOs.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 03.02.26.
//

import Foundation
import AppPresentationModel

struct CommunityDTO {
    
    struct Response: Decodable {
        let communityId: Int?
        let visibility: AppPresentationModel.AccessType
        let name: String
        let ownerContact: String
        let location: String?
        let about: String
        let rule: String?
        let capacity: Int?
        let communityName: String?
        let links: [Link]?
        let categories: [Category]
    }
    
    struct Category: Decodable {
        let id: Int
        let title: String
    }
    
    struct MemberResponse: Decodable {
        let content: [Member]
        
        struct Member: Decodable {
            let userId: String?
            let role: AppPresentationModel.UserActivityRole
            let fullName: String?
            let profileUrl: String?
            let degree: String?
            let specialization: String?
            let entryYear: Int?
        }
    }
    
    struct Link: Codable {
        let type: String
        let name: String
        let url: String
    }
}
