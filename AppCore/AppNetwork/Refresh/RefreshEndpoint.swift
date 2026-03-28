//
//  RefreshEndpoint.swift
//  AppCore
//
//  Created by Huseyn Hasanov on 24.11.25.
//



import Foundation

enum RefreshEndpoint: AppEndPoint {
    case refresh(RefreshTokenRequest)
    
    var path: String {
        switch self {
        case .refresh:
            "/api/as/v1/auth/refresh"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .refresh:
                .post
        }
    }
    
    var body: Encodable? {
        switch self {
        case .refresh(let body):
            return body
        }
    }
}
