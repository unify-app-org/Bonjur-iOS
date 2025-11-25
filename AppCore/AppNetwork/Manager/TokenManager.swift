//
//  TokenManager.swift
//  AppCore
//
//  Created by Huseyn Hasanov on 24.11.25.
//

import Foundation
import AppStorage

protocol TokenManager {
    func saveAccessToken(_ token: String)
    func getAccessToken() -> String?
    
    func saveRefreshToken(_ token: String)
    func getRefreshToken() -> String?
    
    func clearTokens()
}

final class TokenManagerImpl: TokenManager {
    
    // MARK: - should change
    private let keychain: KeychainProtocol
    
    init(keychain: KeychainProtocol = resolve()) {
        self.keychain = keychain
    }
    
    // MARK: - Access Token
    
    func saveAccessToken(_ token: String) {
        keychain.saveString(key: .token, value: token)
    }
    
    func getAccessToken() -> String? {
        keychain.getString(key: .token)
    }
    
    // MARK: - Refresh Token
    
    func saveRefreshToken(_ token: String) {
        keychain.saveString(key: .refreshToken, value: token)
    }
    
    func getRefreshToken() -> String? {
        keychain.getString(key: .refreshToken)
    }
    
    // MARK: - Clear
    
    func clearTokens() {
        keychain.delete(.refreshToken, .token)
    }
}
