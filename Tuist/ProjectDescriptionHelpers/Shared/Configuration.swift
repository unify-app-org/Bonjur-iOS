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
}
