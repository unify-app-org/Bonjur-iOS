//
//  AuthDTO.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 19.03.26.
//

import Foundation

enum AuthDTOModel {
    
    //MARK: - Login
    
    struct LoginRequest: Encodable {
        let mail: String
        let deviceId: String
        let devicePlatform: String
        let deviceOs: String
        let deviceModel: String
        let appVersion: String
        let password: String?
    }
    
    struct LoginResponse: Decodable {
        let accessToken: String
        let refreshToken: String
        let userId: String
    }
}
