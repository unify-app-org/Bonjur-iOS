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
    case sendOptionals(
        MultipartFormData?,
        [String : String]?
    )
    case getLanguages
    case getCategories
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
        case .getLanguages:
            "api/sd/v1/languages"
        case .getCategories:
            "api/v1/categories"
        case .sendOptionals:
            "api/us/v1/users"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .register,
                .login:
                .post
        case .getCommunities,
                .getLanguages,
                .getCategories:
                .get
        case .sendOptionals:
                .put
        }
    }
    
    var body: Encodable? {
        switch self {
        case .register(let body),
                .login(let body):
            body
        default:
            nil
        }
    }
    
    var queryParameters: [String : String]? {
        switch self {
        case .sendOptionals(_, let queryParam):
            queryParam
        default:
            nil
        }
    }
    
    var requiresAuth: Bool {
        switch self {
        case .sendOptionals:
            true
        default:
            false
        }
    }
    
    var multipartFormData: MultipartFormData? {
        switch self {
        case .sendOptionals(let multiPart, _):
            multiPart
        default:
            nil
        }
    }
    
    var contentType: ContentType {
        switch self {
        case .sendOptionals:
                .formData
        default:
                .json
        }
    }
}
