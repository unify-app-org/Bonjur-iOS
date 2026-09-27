//
//  SupportContact.swift
//  ProfileImpl
//
//  Public contact points shown from Settings. Keep in sync with Android
//  `SupportContact.kt`.
//

import Foundation
import AppUIKit

enum SupportContact {
    static let email = "unifyapp2026@gmail.com"
    static let emailSubject = "Unify support"

    /// Lives in AppUIKit so sign-in can show the same document.
    static let termsURL = LegalLinks.termsURL

    static var emailURL: URL? {
        var components = URLComponents()
        components.scheme = "mailto"
        components.path = email
        components.queryItems = [URLQueryItem(name: "subject", value: emailSubject)]
        return components.url
    }
}
