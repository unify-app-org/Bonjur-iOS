//
//  KeychainKeys.swift
//  AppCore
//
//  Created by Huseyn Hasanov on 24.11.25.
//


public enum KeychainKeys: String {
    case token
    case refreshToken
    case userId
    /// Email the user signed in with. Prefills the owner-contact field on the
    /// club / event / hangout create forms.
    case userEmail
}