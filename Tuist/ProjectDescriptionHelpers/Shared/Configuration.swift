//
//  Configuration.swift
//  Manifests
//
//  Created by Huseyn Hasanov on 19.12.25.
//

import ProjectDescription

public extension Array where Element == ProjectDescription.Configuration {
    static let `default`: [ProjectDescription.Configuration] = {
        [
            .debug(name: "Debug", xcconfig: "Config/Test.xcconfig"),
            .release(name: "Release", xcconfig: "Config/Prod.xcconfig"),
            .release(name: "Staging", xcconfig: "Config/Staging.xcconfig")
        ]
    }()
    
    static let withoutConfigFile: [ProjectDescription.Configuration] = {
        [
            .debug(name: "Debug"),
            .release(name: "Release"),
            .release(name: "Staging")
        ]
    }()
}

public extension Dictionary where Element == ProjectDescription.SettingsDictionary.Element {
    static let `default`: ProjectDescription.SettingsDictionary = {
        [
            "ENABLE_MODULE_VERIFIER": "YES",
            "ASSETCATALOG_COMPILER_GENERATE_ASSET_SYMBOLS": "YES",
            "CLANG_ENABLE_MODULE_VERIFIER": "YES",
            "CLANG_ENABLE_MODULE_VERIFIER_SUPPORTED_LANGUAGES": "Objective-C Objective-C++",
            "CLANG_ENABLE_MODULES": "YES",
            "DEFINES_MODULE": "YES"
        ]
    }()
}
