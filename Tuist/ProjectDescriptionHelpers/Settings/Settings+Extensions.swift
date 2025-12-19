//
//  Settings+Extensions.swift
//  Manifests
//
//  Created by Huseyn Hasanov on 19.12.25.
//


import Foundation
import ProjectDescription

public extension Settings {
    enum ConcurrencyMode: String {
        case minimal
        case targeted
        case complete
    }
    
    func withAssetGenerationEnabled() -> Self {
        merge(
            with: ["ASSETCATALOG_COMPILER_GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS": "YES"]
        )
    }
    
    func withSwift6Enabled(mode: ConcurrencyMode = .complete) -> Self {
        merge(
            with: [
                "SWIFT_VERSION": "6.0",
                "SWIFT_STRICT_CONCURRENCY": .string(mode.rawValue)
            ]
        )
    }
    
    func merge(with base: SettingsDictionary) -> Self {
        .settings(
            base: self.base.merging(base),
            configurations: configurations,
            defaultSettings: defaultSettings
        )
    }
}
