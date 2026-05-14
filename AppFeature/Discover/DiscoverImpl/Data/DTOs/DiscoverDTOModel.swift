//
//  DiscoverDTOModel.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 11.05.26.
//

import Foundation
import AppPresentationModel

struct DiscoverDTOModel {
    
    struct CategoryResponse: Decodable {
        let id: Int?
        let title: String?
    }
    
    public struct PaginationQuery: Encodable {
        let page: Int
        let size: Int
    }
    
    struct Member: Decodable {
        let id: String?
        let fullName: String?
        let url: String?
    }
    
    // MARK: - Hangout
    
    struct Hangout: Decodable {
        let id: String?
        let name: String?
        let visibility: AppPresentationModel.AccessType?
        let about: String?
        let capacity: Int?
        let membersCount: Int?
        let categoryResponses: [CategoryResponse]
    }
    
    // MARK: - Club
    
    struct Club: Decodable {
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
    
    // MARK: - Community
    
    struct Community: Decodable {
        let id: Int?
        let name: String?
        let membersCount: Int?
        let profile, backgroundUrl: String?
        let members: [Member]?
        let background: AppPresentationModel.BackgroundType?
        
        enum CodingKeys: String, CodingKey {
            case id
            case name
            case membersCount
            case profile
            case backgroundUrl
            case members
            case background = "backgroundColour"
        }
    }
}
