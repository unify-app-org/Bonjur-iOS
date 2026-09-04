//
//  WidgetLocalization.swift
//  UnifyWidget
//
//  Created by Huseyn Hasanov on 04.09.26.
//

import Foundation
import AppWidgetShared

/// String lookup for the widget, in the language the *app* is set to.
///
/// The extension deliberately does not link `AppLocalization` — that would drag DI
/// and the app's `UserDefaults.standard` into a memory-capped process, and the
/// standard defaults are not shared with the extension anyway. So this mirrors what
/// `AppLocalizationImpl.localizedString` does, over the widget's own
/// `{en,az,ru}.lproj`, with the language read from the App Group.
///
/// Keys match the Android widget's `widget_strings.xml` one-for-one.
enum WidgetStrings {

    static var displayName: String { localized("widget_user_card_label") }
    static var description: String { localized("widget_user_card_description") }

    static var course: String { localized("widget_user_card_course") }
    static var degree: String { localized("widget_user_card_degree") }
    static var entry: String { localized("widget_user_card_entry") }

    static var signInTitle: String { localized("widget_sign_in_title") }
    static var signInSubtitle: String { localized("widget_sign_in_subtitle") }

    static var pendingTitle: String { localized("widget_card_pending_title") }
    static var pendingSubtitle: String { localized("widget_card_pending_subtitle") }

    /// The app's chosen language, falling back to the device's when the app has not
    /// written one yet (a build older than the mirror, or a fresh install).
    private static var languageCode: String {
        let stored = UserCardWidgetStore.loadLanguage()
        let code = stored ?? Locale.preferredLanguages.first.map { String($0.prefix(2)) }
        return (code ?? "en").lowercased()
    }

    /// Resolved per call, never cached: the timeline is rebuilt on a language switch
    /// and a `static let` would freeze the language picked at first render — the same
    /// trap Android hit with enum constants resolving at class load.
    private static func localized(_ key: String) -> String {
        let bundle = Bundle(for: BundleToken.self)

        if let path = bundle.path(forResource: languageCode, ofType: "lproj"),
           let localeBundle = Bundle(path: path) {
            let value = localeBundle.localizedString(forKey: key, value: nil, table: "Localizable")
            if value != key { return value }
        }

        // Unknown/missing language: fall back to English rather than showing the key.
        if languageCode != "en",
           let path = bundle.path(forResource: "en", ofType: "lproj"),
           let localeBundle = Bundle(path: path) {
            return localeBundle.localizedString(forKey: key, value: nil, table: "Localizable")
        }

        return key
    }
}

/// Anchors `Bundle(for:)` to the widget extension's own bundle. `Bundle.main` in an
/// extension is the extension, but this stays explicit and survives being moved.
private final class BundleToken {}
