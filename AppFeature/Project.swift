import ProjectDescription

let project = Project(
    name: "AppFeature",
    targets: [
        // AppAuth Interface
        .target(
            name: "AppAuth",
            destinations: [.iPhone, .iPad],
            product: .framework,
            bundleId: "com.Bonjur.AppAuth",
            deploymentTargets: .iOS("15.0"),
            sources: ["AppAuth/AppAuth/**"],
            resources: [],
            dependencies: []
        ),

        // AppAuth Implementation
        .target(
            name: "AppAuthImpl",
            destinations: [.iPhone, .iPad],
            product: .framework,
            bundleId: "com.Bonjur.AppAuthImpl",
            deploymentTargets: .iOS("15.0"),
            sources: ["AppAuth/AppAuthImpl/**"],
            resources: [],
            dependencies: [
                .target(name: "AppAuth"),
                .project(target: "AppFoundation", path: "../AppCore"),
                .project(target: "AppNetwork", path: "../AppCore")
            ]
        )
    ]
)

