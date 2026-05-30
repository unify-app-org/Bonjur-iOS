//
//  ClubsEndPoint.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 20.01.26.
//

import AppNetwork

enum ClubsEndPoint {
    case createClub(MultipartFormData)
    case getCategories
    case getClubs([String: String])
    case getClubById(Int)
    case getMembersByClubId(Int)
    case editClub(Int, MultipartFormData)
    case joinClub(Int)
}

extension ClubsEndPoint: AppEndPoint {
    
    var path: String {
        switch self {
        case .createClub:
            "api/cs/v1/clubs"
        case .getCategories:
            "api/sd/v1/categories"
        case .getClubs:
            "api/ds/v1/clubs"
        case .getClubById(let id):
            "api/cs/v1/clubs/\(id)"
        case .getMembersByClubId(let id):
            "api/cs/v1/clubs/\(id)/members"
        case .editClub(let id, _):
            "api/cs/v1/clubs/\(id)"
        case .joinClub(let id):
            "api/cs/v1/clubs/\(id)/join-club"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .createClub,
                .joinClub:
                .post
        case .getCategories,
                .getClubs,
                .getClubById,
                .getMembersByClubId:
                .get
        case .editClub:
                .put
        }
    }
    
    var multipartFormData: MultipartFormData? {
        switch self {
        case .createClub(let multiPart),
                .editClub(_, let multiPart):
            multiPart
        default:
            nil
        }
    }
    
    var queryParameters: [String: String]? {
        switch self {
        case .getClubs(let query):
            query
        default:
            nil
        }
    }

    var contentType: ContentType {
        switch self {
        case .createClub,
                .editClub:
                .formData
        default:
                .json
        }
    }
}
