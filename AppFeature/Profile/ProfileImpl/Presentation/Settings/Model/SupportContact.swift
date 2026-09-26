//
//  SupportContact.swift
//  ProfileImpl
//
//  Public contact points shown from Settings. Keep in sync with Android
//  `SupportContact.kt`.
//

import Foundation

enum SupportContact {
    static let email = "unifyapp2026@gmail.com"
    static let emailSubject = "Unify support"

    /// Google Doc (shared "anyone with the link"). `/mobilebasic` is Google's
    /// read-only reader view — `/edit` would drop the user into the editor.
    static let termsURL = URL(
        string: "https://docs.google.com/document/d/15iHIcgQvaHAG80U_0mOgehCm8RQfvn68Qdgdwv8viY0/mobilebasic"
    )!

    static var emailURL: URL? {
        var components = URLComponents()
        components.scheme = "mailto"
        components.path = email
        components.queryItems = [URLQueryItem(name: "subject", value: emailSubject)]
        return components.url
    }
}
