//
//  ProfileDTOModel.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 11.05.26.
//

import Foundation
import AppPresentationModel

struct ProfileDTOModel {
    
    //MARK: - Request
    
    struct UpdateRequest: Encodable {
        let birthDate: String?
        let gender: String?
        let about: String?
        let categoriesId: [Int]
        let languagesId: [Int]
        let background: AppPresentationModel.BackgroundType?
        
        enum CodingKeys: String, CodingKey {
            case birthDate
            case gender
            case about
            case categoriesId
            case languagesId
            case background = "backgroundColour"
        }
    }

    //MARK: - Statics

    struct CategoriesResponse: Decodable {
        let type, title: String?
        let subCategories: [SubCategoriesResponse]
    }

    struct SubCategoriesResponse: Decodable {
        let id: Int?
        let title: String?
    }
    
    struct LanguagesResponse: Decodable {
        let id: Int
        let name, code: String?
    }
    
    //MARK: - Clubs
    
    struct MyClubListResponse: Decodable {
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
        let members: [ListMember]?
        let eventCount: Int?
        let categoryResponses: [CategoryResponse]?

        struct ListMember: Decodable {
            let id: String?
            let fullName: String?
            let url: String?
        }
    }
    
    struct HangoutItem: Decodable {
        let id: String?
        let name: String?
        let visibility: AppPresentationModel.AccessType?
        let status: AppPresentationModel.RequestType?
        let role: AppPresentationModel.UserActivityRole?
        let hangoutActivityStatus: AppPresentationModel.ActivityStatus?
        let about: String?
        let capacity: Int?
        let membersCount: Int?
        let categories: [CategoryResponse]
        let location: String?
        let hangoutDate: String?
    }

    struct CategoryResponse: Decodable {
        let id: Int?
        let title: String?
    }

    //MARK: - Events

    struct MyEventResponse: Decodable {
        let id: String?
        let name: String?
        let visibility: AppPresentationModel.AccessType?
        let about: String?
        let capacity: Int?
        let membersCount: Int?
        let background: String?
        let requestStatus: AppPresentationModel.RequestType?
        let eventActivityStatus: AppPresentationModel.ActivityStatus?
        let role: AppPresentationModel.UserActivityRole?
        let categoryResponses: [CategoryResponse]
        let club: Club?
        let location: String?
        let eventDate: String?

        struct Club: Decodable {
            let id: Int?
            let name: String?
        }
    }
}
