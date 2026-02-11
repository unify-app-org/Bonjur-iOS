//
//  Schemes.swift
//  Manifests
//
//  Created by Huseyn Hasanov on 19.12.25.
//

import ProjectDescription

public extension Scheme {
    static let prodScheme: Self = .scheme(
        name: "Unify-Release",
        shared: true,
        buildAction: .buildAction(
            targets: ["App"]
        ),
        testAction: .targets(
            ["App"],
            configuration: "Release"
        ),
        runAction: .runAction(
            configuration: "Release"
        ),
        archiveAction: .archiveAction(
            configuration: "Release"
        ),
        profileAction: .profileAction(
            configuration: "Release"
        )
    )
    
    static let testScheme: Self = .scheme(
        name: "Unify-Test",
        shared: true,
        buildAction: .buildAction(
            targets: ["App"]
        ),
        testAction: .targets(
            ["App"],
            configuration: "Debug"
        ),
        runAction: .runAction(
            configuration: "Debug"
        ),
        archiveAction: .archiveAction(
            configuration: "Debug"
        ),
        profileAction: .profileAction(
            configuration: "Debug"
        )
    )

    static let stagingScheme: Self = .scheme(
        name: "Unify-Staging",
        shared: true,
        buildAction: .buildAction(
            targets: ["App"]
        ),
        testAction: .targets(
            ["App"],
            configuration: "Staging"
        ),
        runAction: .runAction(
            configuration: "Staging"
        ),
        archiveAction: .archiveAction(
            configuration: "Staging"
        ),
        profileAction: .profileAction(
            configuration: "Staging"
        )
    )
    
}
