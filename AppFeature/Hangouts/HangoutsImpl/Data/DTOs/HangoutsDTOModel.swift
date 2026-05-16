//
//  HangoutsDTOModel.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 16.05.26.
//

import AppPresentationModel
import Foundation

struct HangoutsDTOModel {
    struct PaginationQuery: Encodable {
        let page: Int
        let size: Int
        let name: String?
    }
    
    struct CategoryResponse: Decodable {
        let id: Int?
        let title: String?
    }
    
    struct Hangout: Decodable {
        let id: String?
        let name: String?
        let visibility: AppPresentationModel.AccessType?
        let about: String?
        let capacity: Int?
        let membersCount: Int?
        let categoryResponses: [CategoryResponse]
    }
}
