//
//  CommunityEndPoint.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 03.02.26.
//

import AppNetwork

enum CommunityEndPoint {
    case getClubById(Int)
    case getMembersByClubId(Int, [String: String])
    case getClubs([String : String])
    case assignRole(Int, CommunityDTO.RoleAssignRequest)
}

extension CommunityEndPoint: AppEndPoint {
    
    var path: String {
        switch self {
        case .getClubById(let id):
            "api/cs/v1/clubs/\(id)"
        case .getMembersByClubId(let id, _):
            "api/cs/v1/clubs/\(id)/members"
        case .getClubs:
            "api/ds/v1/clubs"
        case .assignRole(let id, _):
            "api/cs/v1/clubs/\(id)/role"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getClubById,
                .getMembersByClubId,
                .getClubs:
                .get
        case .assignRole:
                .post
        }
    }

    var queryParameters: [String : String]? {
        switch self {
        case .getClubs(let query):
                query
        case .getMembersByClubId(_, let query):
                query
        default:
            nil
        }
    }

    var body: Encodable? {
        switch self {
        case .assignRole(_, let request):
            request
        default:
            nil
        }
    }
}
