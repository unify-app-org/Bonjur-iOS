//
//  CommunityEndPoint.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 03.02.26.
//

import AppNetwork

enum CommunityEndPoint {
    case test
}

extension CommunityEndPoint: AppEndPoint {
    
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
