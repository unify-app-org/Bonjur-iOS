//
//  HangoutsEndPoint 2.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 22.01.26.
//


import AppNetwork

enum HangoutsEndPoint {
    case getHangouts([String: String])
    case hangoutDetail(String)
    case members(String)
}

extension HangoutsEndPoint: AppEndPoint {
    
    var path: String {
        switch self {
        case .getHangouts:
            "api/ds/v1/hangouts"
        case .hangoutDetail(let id):
            "api/hs/v1/hangouts/\(id)"
        case .members(let id):
            "api/hs/v1/hangouts/\(id)/members"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getHangouts,
                .hangoutDetail,
                .members:
                .get
        }
    }

    var queryParameters: [String: String]? {
        switch self {
        case .getHangouts(let query):
            query
        default:
            nil
        }
    }
}
