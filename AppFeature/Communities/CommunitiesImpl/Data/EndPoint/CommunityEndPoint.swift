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
}

extension CommunityEndPoint: AppEndPoint {
    
    var path: String {
        switch self {
        case .getClubById(let id):
            "api/cs/v1/clubs/\(id)"
        case .getMembersByClubId(let id):
            "api/cs/v1/clubs/\(id)/members"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getClubById,
                .getMembersByClubId:
                .get
        }
    }
}
