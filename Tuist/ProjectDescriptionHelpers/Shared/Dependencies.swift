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
            .AppCore.AppNetwork,
            .AppCore.AppPresentationModel
        ]
    }
    
    
    static var FeaturesDependencies: [Self] {
        [
            .AppFeature.AppAuth,
            .AppFeature.AppAuthImpl,
            .AppFeature.Discover,
            .AppFeature.DiscoverImpl,
            .AppFeature.Communities,
            .AppFeature.CommunitiesImpl,
            .AppFeature.Hangouts,
            .AppFeature.HangoutsImpl,
            .AppFeature.Events,
            .AppFeature.EventsImpl,
            .AppFeature.Clubs,
            .AppFeature.ClubsImpl,
            .AppFeature.Groups,
            .AppFeature.GroupsImpl
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
        
        public static let AppPresentationModel: TargetDependency = .project(
            target: "AppPresentationModel",
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
        
        // Clubs
        public static let Clubs: TargetDependency = .project(
            target: "Clubs",
            path: .relativeToRoot(Project.Projects.features)
        )
        
        public static let ClubsImpl: TargetDependency = .project(
            target: "ClubsImpl",
            path: .relativeToRoot(Project.Projects.features)
        )
        
        // Clubs
        public static let Groups: TargetDependency = .project(
            target: "Groups",
            path: .relativeToRoot(Project.Projects.features)
        )
        
        public static let GroupsImpl: TargetDependency = .project(
            target: "GroupsImpl",
            path: .relativeToRoot(Project.Projects.features)
        )
        
        
        // Events
        public static let Events: TargetDependency = .project(
            target: "Events",
            path: .relativeToRoot(Project.Projects.features)
        )
        
        public static let EventsImpl: TargetDependency = .project(
            target: "EventsImpl",
            path: .relativeToRoot(Project.Projects.features)
        )
        
        // Hangouts
        public static let Hangouts: TargetDependency = .project(
            target: "Hangouts",
            path: .relativeToRoot(Project.Projects.features)
        )
        
        public static let HangoutsImpl: TargetDependency = .project(
            target: "HangoutsImpl",
            path: .relativeToRoot(Project.Projects.features)
        )
        
        // Communities
        public static let Communities: TargetDependency = .project(
            target: "Communities",
            path: .relativeToRoot(Project.Projects.features)
        )
        
        public static let CommunitiesImpl: TargetDependency = .project(
            target: "CommunitiesImpl",
            path: .relativeToRoot(Project.Projects.features)
        )
    }
    
    
    enum TestHelpers {
        public static let SnapshotTesting: TargetDependency = .external(name: "SnapshotTesting")
    }
}

