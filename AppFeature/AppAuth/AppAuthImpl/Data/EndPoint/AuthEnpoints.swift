//
//  AuthEnpoints.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 24.11.25.
//

import AppNetwork

enum AuthEnpoints {
    case login(Encodable)
    case register(Encodable)
    case getCommunities
}

extension AuthEnpoints: AppEndPoint {
    
    var path: String {
        switch self {
        case .login:
            "api/as/v1/auth/login"
        case .register:
            "auth/register"
        case .getCommunities:
            "api/sd/v1/communities"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .register,
                .login:
                .post
        case .getCommunities:
                .get
        }
    }
    
    var body: Encodable? {
        switch self {
        case .register(let body),
                .login(let body):
            body
        case .getCommunities:
            nil
        }
    }
    
    var requiresAuth: Bool {
        false
    }
}
