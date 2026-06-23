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
            "DEFINES_MODULE": "YES",
            "MARKETING_VERSION": "\(Project.marketingVersion)",
            "CURRENT_PROJECT_VERSION": "1"
        ]
    }()
    
    static let mainTargetBuildSettings: ProjectDescription.SettingsDictionary = {
        [
            "ENABLE_MODULE_VERIFIER": "YES",
            "ASSETCATALOG_COMPILER_GENERATE_ASSET_SYMBOLS": "YES",
            "CLANG_ENABLE_MODULE_VERIFIER": "YES",
            "CLANG_ENABLE_MODULE_VERIFIER_SUPPORTED_LANGUAGES": "Objective-C Objective-C++",
            "CLANG_ENABLE_MODULES": "YES",
            "DEFINES_MODULE": "YES",
            "ASSETCATALOG_COMPILER_APPICON_NAME": "AppIcon.${ENVIRONMENT}",
            "MARKETING_VERSION": "\(Project.marketingVersion)",
            "CURRENT_PROJECT_VERSION": "$(CURRENT_PROJECT_VERSION)",
            // Required so Obj-C categories in Firebase's static deps (e.g. GoogleUtilities
            // NSData+GTMGzip → `gul_dataByGzippingData:`) are loaded; otherwise the
            // selector is stripped and crashes at runtime.
            "OTHER_LDFLAGS": "$(inherited) -ObjC"
        ]
    }()
}
