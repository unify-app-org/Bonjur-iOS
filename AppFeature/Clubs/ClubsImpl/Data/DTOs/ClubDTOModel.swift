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
        let keyword: String?
        let categoryIds: [Int]?

        init(
            page: Int,
            size: Int,
            keyword: String?,
            categoryIds: [Int]? = nil
        ) {
            self.page = page
            self.size = size
            self.keyword = keyword
            self.categoryIds = categoryIds
        }
    }

    /// Body for `POST /v1/clubs/{clubId}/role`. Communities reuse the same
    /// route — the community id is passed as the club id.
    struct RoleAssignRequest: Encodable {
        let userId: String
        let role: AppPresentationModel.UserActivityRole
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

    // MARK: - Create response

    struct CreateResponse: Decodable {
        let id: Int?
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
        let capacity, eventCount, clubCount: Int?
        let communityName: String
        let backgroundUrl, logoUrl, modifiedAt: String?
        let backgroundColour: AppPresentationModel.BackgroundType?
        let clubUserRole: AppPresentationModel.UserActivityRole?
        let clubUserStatus: AppPresentationModel.RequestType?
        let status: AppPresentationModel.ClubStatus?
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
        let memberCount, capacity: Int?
        let requestStatus: AppPresentationModel.RequestType?
        let role: AppPresentationModel.UserActivityRole?
        let clubStatus: AppPresentationModel.ClubStatus?
        let members: [ListMember]?
        let eventCount: Int?
        let categoryResponses: [Category]?
    }

    struct MemberResponse: Decodable {
        let content: [Member]
        let page: Int?
        let size: Int?
        let totalPages: Int?
        let totalElements: Int?
        /// Rows in *this* page — the server sends it alongside the page metadata.
        let numberOfElements: Int?

        /// True when a further page exists. Prefers the page metadata; falls back to
        /// "this page came back full" so paging still works if `page`/`totalPages` ever
        /// go missing (they'd otherwise decode as nil and silently end the list).
        var hasMore: Bool {
            if let page, let totalPages { return page + 1 < totalPages }
            let received = numberOfElements ?? content.count
            guard let size, size > 0 else { return false }
            return received >= size
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
}
