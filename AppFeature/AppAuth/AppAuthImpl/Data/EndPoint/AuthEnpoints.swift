//
//  AuthEnpoints.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 24.11.25.
//

import AppNetwork

enum AuthEnpoints {
    case register(RegisterRequest)
}

extension AuthEnpoints: AppEndPoint {
    
    var path: String {
        switch self {
        case .register:
            "auth/register"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .register:
                .post
        }
    }
    
    var body: Encodable? {
        switch self {
        case .register(let body):
            return body
        }
    }
}
