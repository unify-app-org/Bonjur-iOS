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
    bundleId: "com.bonjur.app",
    deploymentTargets: .iOS("15.0"),
    infoPlist: "App/Info.plist",
    sources: ["App/**/*.swift"],
    resources: ["App/Resources/**"],
    dependencies: TargetDependency.AllDependencies,
    settings: .settings(configurations: .default)
)

let project = Project(
    name: Project.Projects.main,
    organizationName: "Bonjur",
    options: .options(automaticSchemesOptions: .disabled),
    settings: .settings(base: .default, configurations: .default),
    targets: [appTarget],
    schemes: [
        .testScheme,
        .prodScheme,
        .stagingScheme
    ]
)
