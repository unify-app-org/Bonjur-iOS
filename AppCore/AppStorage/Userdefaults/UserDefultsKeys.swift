//
//  UserDefultsKeys.swift
//  AppCore
//
//  Created by Huseyn Hasanov on 24.11.25.
//

import Foundation

public enum UserDefultsKeys: String {
    case isDarkModeEnabled
    case userCommunityRole
    case isAuthenticated
    case communityId
    /// User ticked "Don't show again" on the event reminder warning alert.
    case hideEventReminderWarning
}

public extension Notification.Name {
    /// Posted once a login has stored its tokens. The app registers the device's FCM
    /// token on it — `PUT api/as/v1/device/{id}` needs a session, so the launch-time
    /// registration is skipped while signed out and this is where it catches up.
    static let userDidLogin = Notification.Name("userDidLogin")
}
