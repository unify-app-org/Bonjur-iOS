//
//  AppLocalization.swift
//  AppCore
//
//  Created by Huseyn Hasanov on 24.11.25.
//

import Foundation

public protocol AppLocalizationProtocol {
    var currentLanguage: String { get }
    func localizedString(_ key: String) -> String
    func registerBundle(_ bundle: Bundle...)
    func setLanguage(_ code: String)
}

public final class AppLocalizationImpl: AppLocalizationProtocol {
        
    // MARK: - Current Language
    
    public var currentLanguage: String {
        get {
            UserDefaults.standard.string(forKey: "AppLanguage") 
            ?? Locale.preferredLanguages.first?.prefix(2).description 
            ?? ""
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "AppLanguage")
        }
    }
    
    // MARK: - Bundles Registry
    
    private var bundles: [Bundle] = []
    
    public init() {
        registerBundle(Bundle.main)
    }
    
    // MARK: - Bundle Registration
    
    public func registerBundle(_ bundles: Bundle...) {
        bundles.forEach { bundle in
            if !self.bundles.contains(bundle) {
                self.bundles.append(bundle)
            }
        }
    }
    
    public func registerBundles(_ bundles: [Bundle]) {
        bundles.forEach { registerBundle($0) }
    }
    
    // MARK: - Language Management
    
    public func setLanguage(_ code: String) {
        currentLanguage = code.lowercased()
        
        NotificationCenter.default.post(
            name: .languageDidChange,
            object: nil,
            userInfo: ["language": code]
        )
    }
    
    // MARK: - Localization
    
    public func localizedString(_ key: String) -> String {
        for bundle in bundles {
            if let localized = getLocalizedString(key, in: bundle), localized != key {
                return localized
            }
        }
        return key
    }
    
    private func getLocalizedString(_ key: String, in bundle: Bundle) -> String? {
        guard let path = bundle.path(forResource: currentLanguage, ofType: "lproj"),
              let localizedBundle = Bundle(path: path) else {
            return nil
        }
        
        let result = localizedBundle.localizedString(
            forKey: key,
            value: nil,
            table: "Localizable"
        )
        
        return result != key ? result : nil
    }
    
    // MARK: - Image Path (Optional)
    
    public func imagePath(name: String, type: String) -> String? {
        for bundle in bundles {
            if let path = bundle.path(forResource: name, ofType: type) {
                return path
            }
        }
        return nil
    }
}

// MARK: - Notification

public extension Notification.Name {
    static let languageDidChange = Notification.Name("languageDidChange")
}
