//
//  Target+FeatureTarget.swift
//  Manifests
//
//  Created by Huseyn Hasanov on 19.12.25.
//

import ProjectDescription

public extension Target {
    static func createFeatureModule(
        name: String,
        path: (String) -> Path = { .relativeToManifest($0) },
        interfaceConfig: FeatureModule.Config = .init(),
        implConfig: FeatureModule.ImplConfig = .init(),
        includeTestTarget: Bool = false
    ) -> FeatureModule {
        let interfaceTarget = Target.createFrameworkTarget(
            name: name,
            deploymentTargets: implConfig.deploymentTargets,
            path: { path("\(name)/\($0)") },
            headers: interfaceConfig.headers,
            settings: interfaceConfig.settings?.withSwift6Enabled() ?? .settings(
                base: ["SWIFT_VERSION": "5.10"]
            ),
            dependencies: interfaceConfig.dependencies + [TargetDependency.AppCore.AppPresentationModel]
        )

        let defaultImplementationDependencies: [TargetDependency] = .CoreDependencies

        let defaultImplementationSettings: Settings = .settings(
            base: ["SWIFT_VERSION": "5.10"]
        ).withAssetGenerationEnabled()

        let implementationTarget = Target.createFrameworkTarget(
            name: "\(name)Impl",
            isReleaseMode: implConfig.isReleaseMode,
            deploymentTargets: implConfig.deploymentTargets,
            infoPlist: implConfig.infoPlist,
            path: { path("\(name)/\($0)") },
            scripts: implConfig.scripts,
            headers: implConfig.headers,
            settings: implConfig.settings ?? defaultImplementationSettings,
            dependencies: [interfaceTarget.targetDependency]
                + implConfig.dependencies
                + defaultImplementationDependencies,
            coreDataModels: implConfig.coreDataModels
        )
        
        let testTarget: BonjurTarget?
        if includeTestTarget {
            testTarget = Target.createTestTarget(
                for: implementationTarget,
                path: { path("\(name)/\($0)") }
            )
        } else {
            testTarget = nil
        }

        return .init(interfaceTarget: interfaceTarget, implementationTarget: implementationTarget, testTarget: testTarget)
    }
}
