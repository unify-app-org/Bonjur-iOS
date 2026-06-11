//
//  ProfileEndPoint.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 04.02.26.
//

import AppNetwork

enum ProfileEndPoint {
    case getUsers
    case updateUserData(
        [String: String]?,
        MultipartFormData?
    )
    case getCategories
    case getLanguages
    case deleteAccount
    case getUserById(String)
    case getMyClubs(String)
    case myHangouts(String)
    case myEvents
}

extension ProfileEndPoint: AppEndPoint {
    
    var path: String {
        switch self {
        case .getUsers:
            "api/us/v1/users/profile"
        case .updateUserData, .deleteAccount:
            "api/us/v1/users"
        case .getUserById(let id):
            "api/us/v1/users/\(id)"
        case .getCategories:
            "api/sd/v1/categories"
        case .getLanguages:
            "api/sd/v1/languages"
        case .getMyClubs(let userId):
            "api/cs/v1/clubs/\(userId)/myclubs"
        case .myHangouts(let id):
            "api/hs/v1/hangouts/\(id)/myhangouts"
        case .myEvents:
            "api/es/v1/events/my"
        }
    }
    
    var queryParameters: [String : String]? {
        switch self {
        case .updateUserData(let query, _):
            query
        default:
            nil
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getUsers,
                .getCategories,
                .getLanguages,
                .getUserById,
                .getMyClubs,
                .myHangouts,
                .myEvents:
                .get
        case .updateUserData:
                .put
        case .deleteAccount:
                .delete
        }
    }
    
    var multipartFormData: MultipartFormData? {
        switch self {
        case .updateUserData(_, let multiPart):
            multiPart
        default:
            nil
        }
    }
    
    var contentType: ContentType {
        switch self {
        case .updateUserData:
                .formData
        default:
                .json
        }
    }
}
