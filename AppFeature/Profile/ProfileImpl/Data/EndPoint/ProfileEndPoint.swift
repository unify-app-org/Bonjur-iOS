//
//  ProfileEndPoint.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 04.02.26.
//

import AppNetwork

enum ProfileEndPoint {
    case test
}

extension ProfileEndPoint: AppEndPoint {
    
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
