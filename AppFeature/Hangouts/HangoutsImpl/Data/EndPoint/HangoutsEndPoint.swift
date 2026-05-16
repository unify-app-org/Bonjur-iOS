//
//  HangoutsEndPoint 2.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 22.01.26.
//




import AppNetwork

enum HangoutsEndPoint {
    case getHangouts([String: String])
}

extension HangoutsEndPoint: AppEndPoint {
    
    var path: String {
        switch self {
        case .getHangouts:
            "api/ds/v1/hangouts"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getHangouts:
                .get
        }
    }

    var queryParameters: [String: String]? {
        switch self {
        case .getHangouts(let query):
            query
        }
    }
}
