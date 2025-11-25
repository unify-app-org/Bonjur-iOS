//
//  RegisterDTO.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 24.11.25.
//

import Foundation

struct RegisterResponse: Decodable {
    let token: String
    let refreshToken: String
}

struct RegisterRequest: Encodable {
    
}
