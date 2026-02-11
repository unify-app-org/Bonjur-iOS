//
//  ClubsEndPoint.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 20.01.26.
//

import AppNetwork

enum ClubsEndPoint {
    case test
}

extension ClubsEndPoint: AppEndPoint {
    
    var path: String {
        switch self {
        case .test:
            "test/test"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .test:
                .post
        }
    }
}
