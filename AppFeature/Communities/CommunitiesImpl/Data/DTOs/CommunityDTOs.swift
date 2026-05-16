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
    
    struct ClubResponse: Decodable {
        let id: Int?
        let name: String?
        let communityName: String?
        let background: AppPresentationModel.BackgroundType?
        let visibility: AppPresentationModel.AccessType?
        let clubProfile: String?
        let backgroundUrl: String?
        let about: String?
        let count, capacity: Int?
        let joined: Bool?
        let members: [Member]?
    }
    
    struct Member: Decodable {
        let id: String?
        let fullName: String?
        let url: String?
    }
    
    public struct PaginationQuery: Encodable {
        let page: Int
        let size: Int
    }
}
