//
//  CommunityDTOs.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 03.02.26.
//

import Foundation
import AppPresentationModel

struct CommunityDTO {

    /// Body for `POST /v1/clubs/{clubId}/role`. A community is modeled as a
    /// club server-side, so the community id is sent as the club id.
    struct RoleAssignRequest: Encodable {
        let userId: String
        let role: AppPresentationModel.UserActivityRole
    }

    struct Response: Decodable {
        let communityId: Int?
        let visibility: AppPresentationModel.AccessType?
        let clubUserRole: AppPresentationModel.UserActivityRole?
        let backgroundColour: AppPresentationModel.BackgroundType?
        let name: String
        let ownerContact: String?
        let location: String?
        let about: String
        let rule, backgroundUrl, logoUrl, modifiedAt: String?
        let capacity, clubCount, eventCount: Int?
        let membersCount: Int?
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
        let page: Int?
        let totalPages: Int?
        let totalElements: Int?

        /// True when a further page exists (Spring Page metadata).
        var hasMore: Bool {
            guard let page, let totalPages else { return false }
            return page + 1 < totalPages
        }

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
        let role: AppPresentationModel.UserActivityRole?
        let clubProfile: String?
        let backgroundUrl: String?
        let about: String?
        let count, capacity: Int?
        let joined: Bool?
        let members: [Member]?
        let eventCount: Int?
        let categoryResponses: [Category]?
        // Same ds/v1/clubs endpoint as Discover, which sends clubStatus → verified badge.
        let clubStatus: AppPresentationModel.ClubStatus?
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
