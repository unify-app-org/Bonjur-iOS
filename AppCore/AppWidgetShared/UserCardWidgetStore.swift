//
//  UserCardWidgetStore.swift
//  AppWidgetShared
//
//  Created by Huseyn Hasanov on 01.09.26.
//

import Foundation

/// Shared App Group storage read by the widget and written by the app.
///
/// Compiled into both the app and the widget extension, so it must stay free
/// of app-only dependencies (no DI, no network, no UIKit).
public enum UserCardWidgetStore {

    /// Must match the `kind` the widget declares.
    public static let widgetKind = "UserCardWidget"

    private static let snapshotKey = "user_card_widget_snapshot"
    private static let signedInKey = "user_card_widget_signed_in"
    private static let languageKey = "user_card_widget_language"
    private static let avatarFileName = "user-card-avatar.jpg"

    /// `group.<app bundle id>`. The widget's own bundle id is the app's plus a
    /// `.widget` suffix, so both processes derive the same group per environment
    /// (prod / staging / test each keep their own container).
    public static var appGroupIdentifier: String {
        let bundleId = Bundle.main.bundleIdentifier ?? ""
        let widgetSuffix = ".widget"
        let appBundleId = bundleId.hasSuffix(widgetSuffix)
            ? String(bundleId.dropLast(widgetSuffix.count))
            : bundleId
        return "group.\(appBundleId)"
    }

    private static var defaults: UserDefaults? {
        UserDefaults(suiteName: appGroupIdentifier)
    }

    private static var containerURL: URL? {
        FileManager.default.containerURL(
            forSecurityApplicationGroupIdentifier: appGroupIdentifier
        )
    }

    // MARK: - Write (app side)

    public static func save(_ snapshot: UserCardWidgetSnapshot) {
        guard let data = try? JSONEncoder().encode(snapshot) else { return }
        defaults?.set(data, forKey: snapshotKey)
        setSignedIn(true)
    }

    /// Mirrors the in-app language into the group.
    ///
    /// `AppLocalizationImpl` keeps the choice in `UserDefaults.standard`, which the
    /// extension cannot see — its container is separate. Without this the widget falls
    /// back to the *device* language and stays English while the app is in Azerbaijani.
    public static func saveLanguage(_ code: String) {
        defaults?.set(code.lowercased(), forKey: languageKey)
    }

    /// Mirrors the app's session state into the group so the widget can tell
    /// "nobody is signed in" from "signed in, but the card hasn't been loaded yet".
    /// The snapshot alone cannot: it is only written when the user opens their own
    /// profile, so a freshly signed-in user has none.
    public static func setSignedIn(_ isSignedIn: Bool) {
        defaults?.set(isSignedIn, forKey: signedInKey)
    }

    /// `nil` leaves the stored avatar untouched — a profile load that failed to
    /// fetch the image should not blank the widget's existing one.
    public static func saveAvatar(_ data: Data?) {
        guard let data, let url = avatarURL else { return }
        try? data.write(to: url, options: .atomic)
    }

    public static func clear() {
        defaults?.removeObject(forKey: snapshotKey)
        setSignedIn(false)
        if let avatarURL {
            try? FileManager.default.removeItem(at: avatarURL)
        }
    }

    // MARK: - Read (widget side)

    public static func loadSignedIn() -> Bool {
        defaults?.bool(forKey: signedInKey) ?? false
    }

    /// The language the app is running in, or `nil` before the app has written one
    /// (first launch of a build that predates the mirror) — callers fall back to the
    /// device language. Deliberately untouched by `clear()`: signing out does not
    /// change what language the sign-in prompt should be written in.
    public static func loadLanguage() -> String? {
        defaults?.string(forKey: languageKey)
    }

    public static func load() -> UserCardWidgetSnapshot? {
        guard let data = defaults?.data(forKey: snapshotKey) else { return nil }
        return try? JSONDecoder().decode(UserCardWidgetSnapshot.self, from: data)
    }

    public static func loadAvatarData() -> Data? {
        guard let avatarURL else { return nil }
        return try? Data(contentsOf: avatarURL)
    }

    private static var avatarURL: URL? {
        containerURL?.appendingPathComponent(avatarFileName)
    }
}
