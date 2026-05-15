//
//  ClubsEndPoint.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 20.01.26.
//

import AppNetwork

enum ClubsEndPoint {
    case createClub(MultipartFormData)
    case getCategories
}

extension ClubsEndPoint: AppEndPoint {
    
    var path: String {
        switch self {
        case .createClub:
            "api/cs/v1/clubs"
        case .getCategories:
            "api/sd/v1/categories"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .createClub:
                .post
        case .getCategories:
                .get
        }
    }
    
    var multipartFormData: MultipartFormData? {
        switch self {
        case .createClub(let multiPart):
            multiPart
        default:
            nil
        }
    }
    
    var contentType: ContentType {
        switch self {
        case .createClub:
                .formData
        default:
                .json
        }
    }
}
