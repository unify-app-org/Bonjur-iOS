//
//  Target+Framework.swift
//  Manifests
//
//  Created by Huseyn Hasanov on 19.12.25.
//


import ProjectDescription

public extension Target {
    static func createFrameworkTarget(
        name: String,
        isReleaseMode: Bool = Project.isReleaseModeOn,
        deploymentTargets: DeploymentTargets = .iOS(Project.deploymentTarget),
        infoPlist: InfoPlist = .default,
        path: (String) -> Path = { .relativeToManifest($0) },
        scripts: [TargetScript] = [],
        headers: Headers? = nil,
        settings: Settings? = nil,
        dependencies: [TargetDependency] = [],
        coreDataModels: [CoreDataModel] = []
    ) -> BonjurTarget {
        let previewSettings: SettingsDictionary = Project.isReleaseModeOn
            ? [:]
            : ["OTHER_SWIFT_FLAGS": "$(inherited) -DPREVIEW"]
        
        let target = createTarget(
            name: name,
            product: .framework,
            bundleId: "com.unify${BUNDLE_ID_SUFFIX}.\(name)",
            deploymentTargets: deploymentTargets,
            infoPlist: infoPlist,
            sources: .sourceFilesList(
                globs: [
                    .glob(
                        path("\(name)/**/*.{\(FileExtension.sources)}"),
                        excluding: []
                    )
                ]
            ),
            resources: [
                .glob(
                    pattern: path("\(name)/**/*.{\(FileExtension.resources())}"),
                    excluding: [],
                    tags: [],
                    inclusionCondition: nil
                ),
                .glob(
                    pattern: path("\(name)/**/*.{\(FileExtension.images)}"),
                    excluding: [],
                    tags: [],
                    inclusionCondition: nil
                ),
            ],
            headers: headers,
            entitlements: nil,
            scripts: scripts,
            dependencies: dependencies,
            settings: settings?.merge(with: previewSettings),
            coreDataModels: coreDataModels
        )
        
        return target
    }
}
