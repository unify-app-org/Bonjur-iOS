//
//  Target+Test.swift
//  Manifests
//
//  Created by Huseyn Hasanov on 19.12.25.
//


import ProjectDescription

public enum TestTargetsContainer {
    public static nonisolated(unsafe) var testTargets: [BonjurTarget] = []
}

public extension Target {
    static func createTestTarget(
        name: String,
        deploymentTargets: DeploymentTargets = .iOS(Project.deploymentTarget),
        infoPlist: InfoPlist = .default,
        path: (String) -> Path = { .relativeToManifest($0) },
        excludings: [Path] = [],
        scripts: [TargetScript] = [],
        headers: Headers? = nil,
        settings: Settings? = nil,
        dependencies: [TargetDependency] = [],
        coreDataModels: [CoreDataModel] = []
    ) -> BonjurTarget {
        let target = createTarget(
            name: name,
            product: .unitTests,
            bundleId: "com.ibamobile${BUNDLE_ID_SUFFIX}.\(name)",
            deploymentTargets: deploymentTargets,
            infoPlist: infoPlist,
            sources: .sourceFilesList(
                globs: [
                    .glob(path("\(name)/**/*.{\(FileExtension.sources)}"))
                ]
            ),
            resources: [
                .glob(pattern: path("\(name)/**/*.{\(FileExtension.resources())}")),
                .glob(pattern: path("\(name)/**/*.{\(FileExtension.images)}")),
            ],
            headers: headers,
            entitlements: nil,
            scripts: scripts,
            dependencies: dependencies,
            settings: settings,
            coreDataModels: coreDataModels
        )
        
        TestTargetsContainer.testTargets.append(target)
        return target
    }
    
    static func createTestTarget(
        for target: BonjurTarget,
        path: (String) -> Path = { .relativeToManifest($0) },
        dependencies: [TargetDependency] = []
    ) -> BonjurTarget {
        createTestTarget(
            name: target.target.name + "Tests",
            path: path,
            dependencies: [
                .TestHelpers.SnapshotTesting,
                
                target.targetDependency,
            ] + dependencies
        )
    }
}
