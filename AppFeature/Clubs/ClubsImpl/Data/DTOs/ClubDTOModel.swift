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
    
    struct CreateRequest: Encodable {
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
}
