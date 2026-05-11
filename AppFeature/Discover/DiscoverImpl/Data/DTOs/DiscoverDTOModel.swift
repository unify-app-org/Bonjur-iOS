//
//  DiscoverDTOModel.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 11.05.26.
//

import Foundation
import AppPresentationModel

struct DiscoverDTOModel {
    
    struct Hangout: Decodable {
        let id: String?
        let name: String?
        let visibility: AppPresentationModel.AccessType?
        let about: String?
        let capacity: Int?
        let membersCount: Int?
        let categoryResponses: [CategoryResponse]
    }
    
    struct CategoryResponse: Decodable {
        let id: Int?
        let title: String?
    }
    
    public struct PaginationQuery: Encodable {
        let page: Int
        let size: Int
    }
}
