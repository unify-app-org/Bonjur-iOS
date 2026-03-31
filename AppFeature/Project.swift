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
            .AppFeature.Clubs,
            .AppFeature.Events,
            .AppFeature.Hangouts,
            .AppFeature.Communities
        ]
    )
).add(to: &frameworkTargets)

let communitiesTarget = Target.createFeatureModule(
    name: "Communities",
    implConfig: .init(
        dependencies: [
            .AppFeature.Clubs,
            .AppFeature.Events
        ]
    )
).add(to: &frameworkTargets)

let eventsTarget = Target.createFeatureModule(
    name: "Events",
    implConfig: .init(
        dependencies: [
            .AppFeature.Clubs,
            .AppFeature.Communities
        ]
    )
).add(to: &frameworkTargets)

let hangoutsTarget = Target.createFeatureModule(
    name: "Hangouts",
    implConfig: .init(
        dependencies: [
            .AppFeature.Communities
        ]
    )
).add(to: &frameworkTargets)

let clubsTarget = Target.createFeatureModule(
    name: "Clubs",
    implConfig: .init(
        dependencies: [
            .AppFeature.Events,
            .AppFeature.Communities,
        ]
    )
).add(to: &frameworkTargets)

let groupsTarget = Target.createFeatureModule(
    name: "Groups",
    implConfig: .init(
        dependencies: [
            .AppFeature.Clubs,
            .AppFeature.Events,
            .AppFeature.Hangouts
        ]
    )
).add(to: &frameworkTargets)

let profileTarget = Target.createFeatureModule(
    name: "Profile",
    implConfig: .init(
        dependencies: [
            .AppFeature.Clubs,
            .AppFeature.Events,
            .AppFeature.Hangouts
        ]
    )
).add(to: &frameworkTargets)

let project = Project(
    name: Project.Projects.features,
    options: .options(automaticSchemesOptions: .disabled),
    settings: .settings(base: .default, configurations: .withoutConfigFile),
    targets: frameworkTargets.map(\.target)
)
