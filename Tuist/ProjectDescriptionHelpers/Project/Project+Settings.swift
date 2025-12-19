//
//  Project+Settings.swift
//  Manifests
//
//  Created by Huseyn Hasanov on 19.12.25.
//

import ProjectDescription

public extension Project {
    static let projectName = "Bonjur"
    static let organizationName = "Bonjur community group"
    static let deploymentTarget = "15.0"

    // TUIST_MARKETING_VERSION
    static let marketingVersion = Environment.marketingVersion.getString(default: "1.0.0")

    // TUIST_ENABLE_AUTO_SIGN
    static let isAutomaticSignEnabled = Environment.enableAutoSign.getBoolean(default: false)

    // TUIST_RELEASE_MODE_ON
    static let isReleaseModeOn = Environment.releaseModeOn.getBoolean(default: false)
}
