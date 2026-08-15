//
//  LanguageManager.swift
//  AppCore
//
//  Live language switching for SwiftUI: publishes the current language code and
//  rebuilds any subtree tagged with `.localized()` when the language changes, so
//  every `.localized` string re-resolves without restarting the app.
//

import SwiftUI
import Combine
import Foundation

public final class LanguageManager: ObservableObject {

    public static let shared = LanguageManager()

    /// Lowercased current language code (e.g. "en", "az", "ru").
    @Published public private(set) var languageCode: String

    private var observer: NSObjectProtocol?

    private init() {
        let localization: AppLocalizationProtocol = resolve()
        languageCode = localization.currentLanguage.lowercased()

        observer = NotificationCenter.default.addObserver(
            forName: .languageDidChange,
            object: nil,
            queue: .main
        ) { [weak self] note in
            let code = (note.userInfo?["language"] as? String)?.lowercased()
                ?? (resolve() as AppLocalizationProtocol).currentLanguage.lowercased()
            self?.languageCode = code
        }
    }

    deinit {
        if let observer {
            NotificationCenter.default.removeObserver(observer)
        }
    }
}

// MARK: - View refresh

public extension View {
    /// Rebuilds this subtree whenever the app language changes so every
    /// `.localized` string (and any `.onAppear`-driven data) re-resolves.
    /// Apply once at each screen's SwiftUI root.
    func localized() -> some View {
        modifier(LocalizedRootModifier())
    }
}

private struct LocalizedRootModifier: ViewModifier {
    @ObservedObject private var manager = LanguageManager.shared

    func body(content: Content) -> some View {
        content.id(manager.languageCode)
    }
}
