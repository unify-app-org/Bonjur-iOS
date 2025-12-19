//
//  Target+createTarget.swift
//  Manifests
//
//  Created by Huseyn Hasanov on 19.12.25.
//

import ProjectDescription

public extension Target {
    static func createTarget(
        name: String,
        product: Product,
        bundleId: String,
        deploymentTargets: DeploymentTargets,
        infoPlist: InfoPlist,
        sources: SourceFilesList?,
        resources: ResourceFileElements?,
        headers: Headers? = nil,
        entitlements: Entitlements?,
        scripts: [TargetScript],
        dependencies: [TargetDependency],
        settings: Settings?,
        coreDataModels: [CoreDataModel] = []
    ) -> BonjurTarget {
        .init(
            target: .target(
                name: name,
                destinations: .iOS,
                product: product,
                bundleId: bundleId,
                deploymentTargets: deploymentTargets,
                infoPlist: infoPlist,
                sources: sources,
                resources: resources,
                headers: headers,
                entitlements: entitlements,
                scripts: scripts,
                dependencies: dependencies,
                settings: settings,
                coreDataModels: coreDataModels,
                environmentVariables: [ "KEY" : "${ENVIRONMENT}" ]
            )
        )
    }
}
