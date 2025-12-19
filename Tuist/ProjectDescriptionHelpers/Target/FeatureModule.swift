//
//  FeatureModule.swift
//  Manifests
//
//  Created by Huseyn Hasanov on 19.12.25.
//

import ProjectDescription

public struct FeatureModule: Sendable {
    public struct Config {
        let headers: Headers?
        let settings: Settings?
        let dependencies: [TargetDependency]
        
        public init(
            headers: Headers? = nil,
            settings: Settings? = nil,
            dependencies: [TargetDependency] = []
        ) {
            self.headers = headers
            self.settings = settings
            self.dependencies = dependencies
        }
    }
    
    public struct ImplConfig {
        let isReleaseMode: Bool
        let deploymentTargets: DeploymentTargets
        let infoPlist: InfoPlist
        let excludings: [Path]
        let scripts: [TargetScript]
        let headers: Headers?
        let settings: Settings?
        let dependencies: [TargetDependency]
        let coreDataModels: [CoreDataModel]
        
        public init(
            isReleaseMode: Bool = Project.isReleaseModeOn,
            deploymentTargets: DeploymentTargets = .iOS(Project.deploymentTarget),
            infoPlist: InfoPlist = .default,
            excludings: [Path] = [],
            scripts: [TargetScript] = [],
            headers: Headers? = nil,
            settings: Settings? = nil,
            dependencies: [TargetDependency] = [],
            coreDataModels: [CoreDataModel] = []
        ) {
            self.isReleaseMode = isReleaseMode
            self.deploymentTargets = deploymentTargets
            self.infoPlist = infoPlist
            self.excludings = excludings
            self.scripts = scripts
            self.headers = headers
            self.settings = settings
            self.dependencies = dependencies
            self.coreDataModels = coreDataModels
        }
    }
    
    public let interfaceTarget: BonjurTarget
    public let implementationTarget: BonjurTarget
    public let testTarget: BonjurTarget?
    
    public init(
        interfaceTarget: BonjurTarget,
        implementationTarget: BonjurTarget,
        testTarget: BonjurTarget?
    ) {
        self.interfaceTarget = interfaceTarget
        self.implementationTarget = implementationTarget
        self.testTarget = testTarget
    }
}

public extension FeatureModule {
    func add(
        to targets: inout [BonjurTarget]
    ) -> Self {
        targets.append(interfaceTarget)
        targets.append(implementationTarget)
        if let testTarget {
            targets.append(testTarget)
        }
        return self
    }
}
