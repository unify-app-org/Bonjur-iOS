//
//  TokenManager.swift
//  AppCore
//
//  Created by Huseyn Hasanov on 24.11.25.
//

import Foundation
import AppStorage

public protocol TokenManager {
    func saveAccessToken(_ token: String) async
    func getAccessToken() async -> String
    
    func saveRefreshToken(_ token: String) async
    func getRefreshToken() async -> String
    
    func saveUserId(_ token: String) async
    func getUserId() async -> String

    func saveUserEmail(_ email: String) async
    func getUserEmail() async -> String
    
    func clearTokens() async
}

public final actor TokenManagerImpl: TokenManager {
    
    // MARK: - should change
    private let keychain: KeychainProtocol
    
    init(keychain: KeychainProtocol = resolve()) {
        self.keychain = keychain
    }
    
    // MARK: - Access Token
    
    public func saveAccessToken(_ token: String) async {
        keychain.saveString(key: .token, value: token)
    }
    
    public func getAccessToken() async -> String {
        keychain.getString(key: .token)
    }
    
    // MARK: - Refresh Token
    
    public func saveRefreshToken(_ token: String) async {
        keychain.saveString(key: .refreshToken, value: token)
    }
    
    public func getRefreshToken() async -> String {
        keychain.getString(key: .refreshToken)
    }
    
    // MARK: - User Id
    
    public func saveUserId(_ token: String) async {
        keychain.saveString(key: .userId, value: token)
    }
    
    public func getUserId() async -> String {
        keychain.getString(key: .userId)
    }
    
    // MARK: - User Email

    /// Stashed at sign-in so the create forms can prefill the owner-contact field.
    public func saveUserEmail(_ email: String) async {
        keychain.saveString(key: .userEmail, value: email)
    }

    public func getUserEmail() async -> String {
        keychain.getString(key: .userEmail)
    }

    // MARK: - Clear
    
    public func clearTokens() async {
        keychain.delete(.refreshToken, .token, .userEmail)
    }
}
