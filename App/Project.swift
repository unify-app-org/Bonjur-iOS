//
//  Project.swift
//  Manifests
//
//  Created by Huseyn Hasanov
//

import ProjectDescription
import ProjectDescriptionHelpers

let appTarget: Target = .target(
    name: "App",
    destinations: [.iPhone, .iPad],
    product: .app,
    bundleId: "$(BUNDLE_ID)",
    deploymentTargets: .iOS(Project.deploymentTarget),
    infoPlist: "App/Info.plist",
    sources: ["App/**/*.swift"],
    resources: ["App/Resources/**"],
    dependencies: TargetDependency.AllDependencies,
    settings: .settings(base: .mainTargetBuildSettings)
)

let project = Project(
    name: Project.Projects.main,
    organizationName: Project.organizationName,
    options: .options(automaticSchemesOptions: .disabled),
    settings: .settings(base: .default, configurations: .default),
    targets: [appTarget],
    schemes: [
        .testScheme,
        .prodScheme,
        .stagingScheme
    ]
)
