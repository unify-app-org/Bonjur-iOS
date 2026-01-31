//
//  Project.swift
//  Manifests
//
//  Created by Huseyn Hasanov
//

import ProjectDescription
import ProjectDescriptionHelpers

nonisolated(unsafe) var frameworkTargets: [BonjurTarget] = []

let appUtilsTarget = Target.createFrameworkTarget(
    name: "AppUtils"
).add(to: &frameworkTargets)

let DITarget = Target.createFrameworkTarget(
    name: "DependecyInjection"
).add(to: &frameworkTargets)

let appStorageTarget = Target.createFrameworkTarget(
    name: "AppStorage",
    dependencies: [
        .AppCore.DependecyInjection
    ]
).add(to: &frameworkTargets)

let appNetworkTarget = Target.createFrameworkTarget(
    name: "AppNetwork",
    dependencies: [
        .AppCore.AppStorage,
        .AppCore.AppUtils
    ]
).add(to: &frameworkTargets)
    
let appFoundationTarget = Target.createFrameworkTarget(
    name: "AppFoundation",
    dependencies: [
        .AppCore.AppUtils,
        .AppCore.AppLocalization,
        .AppCore.DependecyInjection
    ]
).add(to: &frameworkTargets)
    
let appUIKitTarget = Target.createFrameworkTarget(
    name: "AppUIKit",
    dependencies: [
        .AppCore.AppUtils
    ]
).add(to: &frameworkTargets)

let appLocalizationTarget = Target.createFrameworkTarget(
    name: "AppLocalization",
    dependencies: [
        .AppCore.DependecyInjection
    ]
).add(to: &frameworkTargets)

let appPresentationModelTarget = Target.createFrameworkTarget(
    name: "AppPresentationModel",
    dependencies: [
        .AppCore.DependecyInjection
    ]
).add(to: &frameworkTargets)

let project = Project(
    name: Project.Projects.core,
    options: .options(automaticSchemesOptions: .disabled),
    settings: .settings(base: .default, configurations: .withoutConfigFile),
    targets: frameworkTargets.map(\.target)
)
