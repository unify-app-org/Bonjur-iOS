//
//  Project.swift
//  Manifests
//
//  Created by Huseyn Hasanov
//

import ProjectDescription
import ProjectDescriptionHelpers

nonisolated(unsafe) var frameworkTargets: [BonjurTarget] = []

let appAuthTarget = Target.createFeatureModule(
    name: "AppAuth",
    implConfig: .init(
        dependencies: [
            
        ]
    )
).add(to: &frameworkTargets)

let discoverTarget = Target.createFeatureModule(
    name: "Discover",
    implConfig: .init(
        dependencies: [
            
        ]
    )
).add(to: &frameworkTargets)

let project = Project(
    name: Project.Projects.features,
    options: .options(automaticSchemesOptions: .disabled),
    settings: .settings(base: .default),
    targets: frameworkTargets.map(\.target)
)
