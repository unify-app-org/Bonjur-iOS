//
//  CommunityEndPoint.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 03.02.26.
//

import AppNetwork

enum CommunityEndPoint {
    case getClubById(Int)
    case getMembersByClubId(Int)
    case getClubs([String : String])
}

extension CommunityEndPoint: AppEndPoint {
    
    var path: String {
        switch self {
        case .getClubById(let id):
            "api/cs/v1/clubs/\(id)"
        case .getMembersByClubId(let id):
            "api/cs/v1/clubs/\(id)/members"
        case .getClubs:
            "api/ds/v1/clubs"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getClubById,
                .getMembersByClubId,
                .getClubs:
                .get
        }
    }
    
    var queryParameters: [String : String]? {
        switch self {
        case .getClubs(let query):
                query
        default:
            nil
        }
    }
}
