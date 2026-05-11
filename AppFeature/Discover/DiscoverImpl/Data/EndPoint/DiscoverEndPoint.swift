//
//  DiscoverEndPoint.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 17.01.26.
//

import AppNetwork

enum DiscoverEndPoint {
    case getHangouts([String : String])
    case getCommunities([String : String])
    case getClubs([String : String])
}

extension DiscoverEndPoint: AppEndPoint {
    
    var path: String {
        switch self {
        case .getHangouts:
            "api/ds/v1/hangouts"
        case .getCommunities:
            "api/ds/v1/communities"
        case .getClubs:
            "api/ds/v1/clubs"
        }
    }
    
    var queryParameters: [String : String]? {
        switch self {
        case .getHangouts(let query),
                .getClubs(let query),
                .getCommunities(let query):
                query
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getHangouts,
                .getClubs,
                .getCommunities:
                .get
        }
    }
}
