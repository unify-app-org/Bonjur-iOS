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
}

extension AuthEnpoints: AppEndPoint {
    
    var path: String {
        switch self {
        case .login:
            "/api/as/v1/auth/login"
        case .register:
            "auth/register"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .register,
                .login:
                .post
        }
    }
    
    var body: Encodable? {
        switch self {
        case .register(let body),
                .login(let body):
            return body
        }
    }
    
    var requiresAuth: Bool {
        return false
    }
}
