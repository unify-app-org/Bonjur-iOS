//
//  GroupsDTOModel.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 26.05.26.
//

import Foundation
import AppPresentationModel

struct GroupsDTOModel {
    
    struct PaginationQuery: Encodable {
        let page: Int
        let size: Int
        let name: String?
    }
    
    struct CategoryResponse: Decodable {
        let id: Int?
        let title: String?
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
        let role: AppPresentationModel.UserActivityRole?
        let hangoutActivityStatus: AppPresentationModel.ActivityStatus?
        let status: AppPresentationModel.RequestType?
        let about: String?
        let capacity: Int?
        let membersCount: Int?
        let categories: [CategoryResponse]
        let location: String?
        let hangoutDate: String?
    }
    
    // MARK: - Event

    struct Event: Decodable {
        let id: String?
        let name: String?
        let visibility: AppPresentationModel.AccessType?
        let about: String?
        let capacity: Int?
        let membersCount: Int?
        let background: String?
        let club: Club?
        let location: String?
        let eventDate: String?
        let requestStatus: AppPresentationModel.RequestType?
        let eventActivityStatus: AppPresentationModel.ActivityStatus?
        let role: AppPresentationModel.UserActivityRole?
        let categoryResponses: [CategoryResponse]
        
        struct Club: Decodable {
            let id: Int?
            let name: String?
        }
    }

    // MARK: - Club

    struct Club: Decodable {
        let id: Int?
        let name: String?
        let communityName: String?
        let background: AppPresentationModel.BackgroundType?
        let visibility: AppPresentationModel.AccessType?
        let role: AppPresentationModel.UserActivityRole?
        let requestStatus: AppPresentationModel.RequestType?
        let clubStatus: AppPresentationModel.ClubStatus?
        let clubProfile: String?
        let backgroundUrl: String?
        let about: String?
        let memberCount, capacity: Int?
        let members: [Member]?
        let eventCount: Int?
        let categoryResponses: [CategoryResponse]?
    }
}
