//
//  GroupsEndPoint.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 23.01.26.
//

import AppNetwork

enum GroupsEndPoint {
    case joinedClubs([String: String])
    case joinedHangouts([String: String])
}

extension GroupsEndPoint: AppEndPoint {
    
    var path: String {
        switch self {
        case .joinedClubs:
            "api/cs/v1/clubs/joined"
        case .joinedHangouts:
            "api/hs/v1/hangouts/get-joined"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .joinedClubs,
                .joinedHangouts:
                .get
        }
    }
    
    var queryParameters: [String: String]? {
        switch self {
        case .joinedClubs(let query),
                .joinedHangouts(let query):
            query
        }
    }
}
