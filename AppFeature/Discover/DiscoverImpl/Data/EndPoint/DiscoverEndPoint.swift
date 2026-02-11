//
//  DiscoverEndPoint.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 17.01.26.
//

import AppNetwork

enum DiscoverEndPoint {
    case test
}

extension DiscoverEndPoint: AppEndPoint {
    
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
