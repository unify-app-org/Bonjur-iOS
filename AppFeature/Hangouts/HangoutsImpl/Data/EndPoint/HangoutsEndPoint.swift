//
//  HangoutsEndPoint 2.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 22.01.26.
//




import AppNetwork

enum HangoutsEndPoint {
    case test
}

extension HangoutsEndPoint: AppEndPoint {
    
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
