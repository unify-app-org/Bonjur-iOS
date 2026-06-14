//
//  ClubDTOModel.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 15.05.26.
//

import Foundation
import AppPresentationModel

struct ClubDTOModel {

    // MARK: - Request

    struct PaginationQuery: Encodable {
        let page: Int
        let size: Int
        let name: String?
    }

    struct Request: Encodable {
        let communityId: Int
        let name: String
        let ownerContact: String
        let about: String
        let visibility: AppPresentationModel.AccessType
        let location: String
        let links: [Link]?
        let backgroundColour: AppPresentationModel.BackgroundType
        let capacity: Int?
        let categoryIds: [Int]
        let rule: String?
    }

    struct Link: Codable {
        let type: String
        let name: String
        let url: String
    }

    // MARK: - Response

    struct Response: Decodable {
        let communityId: Int
        let membersCount: Int?
        let visibility: AppPresentationModel.AccessType
        let name: String
        let ownerContact: String?
        let location: String?
        let about: String
        let rule: String?
        let capacity: Int?
        let communityName: String
        let backgroundUrl, logoUrl, modifiedAt: String?
        let backgroundColour: AppPresentationModel.BackgroundType?
        let clubUserRole: AppPresentationModel.UserActivityRole?
        let requestType: AppPresentationModel.RequestType?
        let links: [Link]?
        let categories: [Category]
    }

    struct Category: Decodable {
        let id: Int
        let title: String
    }

    struct ListMember: Decodable {
        let id: String?
        let fullName: String?
        let url: String?
    }

    struct ListResponse: Decodable {
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
        let clubUserRole: AppPresentationModel.UserActivityRole?
        let members: [ListMember]?
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
}
