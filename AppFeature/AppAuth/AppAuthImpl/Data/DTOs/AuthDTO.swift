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
        let communityId: Int
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
    
    //MARK: - Communities
    
    struct CommunitiesResponse: Decodable {
        let id: Int
        let name: String
    }
    
    struct OptionalsQuery: Encodable {
        let birthDate: String?
        let gender: String?
        let about: String?
        let categoriesId: [Int]
        let languagesId: [Int]
    }
    
    //MARK: - Statics
    
    struct CategoriesResponse: Decodable {
        let id: Int
        let title: String
    }
    
    struct LanguagesResponse: Decodable {
        let id: Int
        let name, code: String?
    }
}
