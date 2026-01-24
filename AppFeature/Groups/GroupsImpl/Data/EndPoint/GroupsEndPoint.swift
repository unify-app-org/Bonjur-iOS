//
//  GroupsEndPoint.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 23.01.26.
//

import AppNetwork

enum GroupsEndPoint {
    case test
}

extension GroupsEndPoint: AppEndPoint {
    
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
