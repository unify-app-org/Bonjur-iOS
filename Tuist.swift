//
//  Tuist.swift
//  Manifests
//
//  Created by Huseyn Hasanov on 27.11.25.
//

import ProjectDescription

let config = Config(
    project: .tuist(
        compatibleXcodeVersions: .all,
        swiftVersion: nil,
        plugins: [],
        generationOptions: .options(
            enforceExplicitDependencies: true
        ),
        installOptions: .options()
    )
)

