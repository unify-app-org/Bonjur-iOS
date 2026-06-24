//
//  HangoutsDTOModel.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 16.05.26.
//

import AppPresentationModel
import Foundation

struct HangoutsDTOModel {
    
    // MARK: - Request
    
    struct PaginationQuery: Encodable {
        let page: Int
        let size: Int
        let name: String?
        let categoryIds: [Int]?

        init(
            page: Int,
            size: Int,
            name: String?,
            categoryIds: [Int]? = nil
        ) {
            self.page = page
            self.size = size
            self.name = name
            self.categoryIds = categoryIds
        }
    }
    
    struct Request: Encodable {
        let visibility: AppPresentationModel.AccessType
        let name: String
        let ownerContact: String
        let categoriesId: [Int]
        let capacity: Int
        let links: [Link]
        let rules: String
        let location: String
        let about: String
        let hangoutDate: String
    }

    struct JoinRequest: Encodable {
        let hangoutId: String
    }
    
    // MARK: - Category
    
    struct CategoryResponse: Decodable {
        let id: Int?
        let title: String?
    }
    
    struct CategoriesResponse: Decodable {
        let type, title: String?
        let subCategories: [SubCategoriesResponse]
    }
    
    struct SubCategoriesResponse: Decodable {
        let id: Int?
        let title: String?
    }
    
    // MARK: - Response
    
    struct Hangout: Decodable {
        let id: String?
        let name: String?
        let visibility: AppPresentationModel.AccessType?
        let requestStatus: AppPresentationModel.RequestType?
        let hangoutActivityStatus: AppPresentationModel.ActivityStatus?
        let about: String?
        let capacity: Int?
        let membersCount: Int?
        let categoryResponses: [CategoryResponse]
        let location: String?
        let hangoutDate: String?
        let role: AppPresentationModel.UserActivityRole?
    }

    struct HangoutDetail: Decodable {
        let id: String
        let name: String
        let about: String?
        let capacity, membersCount: Int?
        let rules: String?
        let location: String?
        let ownerContact: String?
        let visibility: AppPresentationModel.AccessType?
        let role: AppPresentationModel.UserActivityRole?
        /// Pending/accepted state for the current user. Optional: backend may omit
        /// it on the detail endpoint; the join button then falls back to Join/Request.
        let requestStatus: AppPresentationModel.RequestType?
        let hangoutDate: String?
        let links: [Link]?
        let community: Community
        let categories: [Categories]
    }
    
    struct Community: Decodable {
        let id: Int
        let name: String
    }
    
    struct Categories: Decodable {
        let id: Int
        let title: String
    }
    
    struct Link: Codable {
        let type: String?
        let name: String?
        let url: String?
    }
    
    struct MemberResponse: Decodable {
        let userId: String?
        let role: AppPresentationModel.UserActivityRole
        let fullName: String?
        let profileUrl: String?
        let degree: String?
        let specialization: String?
        let entryYear: Int?
    }
}
