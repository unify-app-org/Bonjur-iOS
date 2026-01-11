//
//  Dependencies.swift
//  Manifests
//
//  Created by Huseyn Hasanov on 19.12.25.
//

import ProjectDescription

public extension Array where Element == TargetDependency {
    static var CoreDependencies: [TargetDependency] {
        TargetDependency.CoreDependencies
    }
}

public extension TargetDependency {
    static var CoreDependencies: [Self] {
        [
            .AppCore.AppFoundation,
            .AppCore.AppUIKit,
            .AppCore.AppStorage,
            .AppCore.AppNetwork
        ]
    }
    
    
    static var FeaturesDependencies: [Self] {
        [
            .AppFeature.AppAuth,
            .AppFeature.AppAuthImpl,
            .AppFeature.Discover,
            .AppFeature.DiscoverImpl
        ]
    }
    
    static var AllDependencies: [Self] {
        CoreDependencies + FeaturesDependencies
    }
    
    enum AppCore {
        public static let AppUtils: TargetDependency = .project(
            target: "AppUtils",
            path: .relativeToRoot(Project.Projects.core)
        )
        
        public static let DependecyInjection: TargetDependency = .project(
            target: "DependecyInjection",
            path: .relativeToRoot(Project.Projects.core)
        )
        
        public static let AppStorage: TargetDependency = .project(
            target: "AppStorage",
            path: .relativeToRoot(Project.Projects.core)
        )
        
        public static let AppNetwork: TargetDependency = .project(
            target: "AppNetwork",
            path: .relativeToRoot(Project.Projects.core)
        )
        
        public static let AppFoundation: TargetDependency = .project(
            target: "AppFoundation",
            path: .relativeToRoot(Project.Projects.core)
        )
        
        public static let AppUIKit: TargetDependency = .project(
            target: "AppUIKit",
            path: .relativeToRoot(Project.Projects.core)
        )
        
        public static let AppLocalization: TargetDependency = .project(
            target: "AppLocalization",
            path: .relativeToRoot(Project.Projects.core)
        )
    }
    
    enum AppFeature {
        // AppAuth
        public static let AppAuth: TargetDependency = .project(
            target: "AppAuth",
            path: .relativeToRoot(Project.Projects.features)
        )
        
        public static let AppAuthImpl: TargetDependency = .project(
            target: "AppAuthImpl",
            path: .relativeToRoot(Project.Projects.features)
        )
        
        // Discover
        public static let Discover: TargetDependency = .project(
            target: "Discover",
            path: .relativeToRoot(Project.Projects.features)
        )
        
        public static let DiscoverImpl: TargetDependency = .project(
            target: "DiscoverImpl",
            path: .relativeToRoot(Project.Projects.features)
        )
        
    }
    
    
    enum TestHelpers {
        public static let SnapshotTesting: TargetDependency = .external(name: "SnapshotTesting")
    }
}

