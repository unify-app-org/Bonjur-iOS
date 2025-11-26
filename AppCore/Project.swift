import ProjectDescription

let project = Project(
    name: "AppCore",
    targets: [
        // AppUtils (no dependencies)
        .target(
            name: "AppUtils",
            destinations: [.iPhone, .iPad],
            product: .framework,
            bundleId: "com.bonjur.AppUtils",
            deploymentTargets: .iOS("15.0"),
            sources: ["AppUtils/**"],
            resources: [],
            dependencies: []
        ),

        // DependencyInjection (no dependencies)
        .target(
            name: "DependecyInjection",
            destinations: [.iPhone, .iPad],
            product: .framework,
            bundleId: "com.bonjur.DependecyInjection",
            deploymentTargets: .iOS("15.0"),
            sources: ["DependecyInjection/**"],
            resources: [],
            dependencies: []
        ),

        // AppStorage (depends on DependencyInjection)
        .target(
            name: "AppStorage",
            destinations: [.iPhone, .iPad],
            product: .framework,
            bundleId: "com.bonjur.AppStorage",
            deploymentTargets: .iOS("15.0"),
            sources: ["AppStorage/**"],
            resources: [],
            dependencies: [
                .target(name: "DependecyInjection")
            ]
        ),

        // AppNetwork (depends on AppStorage and AppUtils)
        .target(
            name: "AppNetwork",
            destinations: [.iPhone, .iPad],
            product: .framework,
            bundleId: "com.bonjur.AppNetwork",
            deploymentTargets: .iOS("15.0"),
            sources: ["AppNetwork/**"],
            resources: [],
            dependencies: [
                .target(name: "AppStorage"),
                .target(name: "AppUtils")
            ]
        ),

        // AppFoundation (depends on AppUtils, AppNetwork, DependencyInjection)
        .target(
            name: "AppFoundation",
            destinations: [.iPhone, .iPad],
            product: .framework,
            bundleId: "com.bonjur.AppFoundation",
            deploymentTargets: .iOS("15.0"),
            sources: ["AppFoundation/**"],
            resources: [],
            dependencies: [
                .target(name: "AppUtils"),
                .target(name: "AppLocalization"),
                .target(name: "DependecyInjection")
            ]
        ),

        // AppUIKit (no dependencies)
        .target(
            name: "AppUIKit",
            destinations: [.iPhone, .iPad],
            product: .framework,
            bundleId: "com.bonjur.AppUIKit",
            deploymentTargets: .iOS("15.0"),
            sources: ["AppUIKit/**"],
            resources: [],
            dependencies: []
        ),

        // AppLocalization (depends on DependencyInjection)
        .target(
            name: "AppLocalization",
            destinations: [.iPhone, .iPad],
            product: .framework,
            bundleId: "com.bonjur.AppLocalization",
            deploymentTargets: .iOS("15.0"),
            sources: ["AppLocalization/**"],
            resources: [],
            dependencies: [
                .target(name: "DependecyInjection")
            ]
        )
    ]
)
