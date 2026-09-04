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
    /// (userId, clubId) — the trailing segment is named clubId server-side but carries the
    /// **community** id: the one stored at login, or the community being viewed when the
    /// profile was opened from a community detail.
    case getUserById(String, Int)
    case getMyClubs(String, [String: String])
    case myHangouts(String, [String: String])
    case myEvents([String: String])
}

extension ProfileEndPoint: AppEndPoint {
    
    var path: String {
        switch self {
        case .getUsers:
            "api/us/v1/users/profile"
        case .updateUserData, .deleteAccount:
            "api/us/v1/users"
        case .getUserById(let id, let clubId):
            "api/us/v1/users/\(id)/\(clubId)"
        case .getCategories:
            "api/sd/v1/categories"
        case .getLanguages:
            "api/sd/v1/languages"
        case .getMyClubs(let userId, _):
            "api/cs/v1/clubs/\(userId)/myclubs"
        case .myHangouts(let id, _):
            "api/hs/v1/hangouts/\(id)/myhangouts"
        case .myEvents:
            "api/es/v1/events/my"
        }
    }
    
    var queryParameters: [String : String]? {
        switch self {
        case .updateUserData(let query, _):
            query
        // Without these the server falls back to page=0&size=10 and every activity
        // list on the profile is silently capped at ten rows.
        case .getMyClubs(_, let query),
                .myHangouts(_, let query),
                .myEvents(let query):
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
