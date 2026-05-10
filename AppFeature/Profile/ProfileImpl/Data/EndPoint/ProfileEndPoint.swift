//
//  ProfileEndPoint.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 04.02.26.
//

import AppNetwork

enum ProfileEndPoint {
    case getUsers
    case updateUserData(MultipartFormData?)
}

extension ProfileEndPoint: AppEndPoint {
    
    var path: String {
        switch self {
        case .getUsers:
            "api/us/v1/users/profile"
        case .updateUserData:
            "api/us/v1/users"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getUsers:
                .get
        case .updateUserData:
                .put
        }
    }
    
    var multipartFormData: MultipartFormData? {
        switch self {
        case .updateUserData(let multiPart):
            multiPart
        default:
            nil
        }
    }
    
    var contentType: ContentType {
        switch self {
        case .updateUserData:
                .formData
        default:
                .json
        }
    }
}
