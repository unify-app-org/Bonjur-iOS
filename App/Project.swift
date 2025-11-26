import ProjectDescription

let project = Project(
    name: "App",
    organizationName: "Bonjur",
    targets: [
        .target(
            name: "App",
            destinations: [.iPhone, .iPad],
            product: .app,
            bundleId: "com.bonjur.app",
            deploymentTargets: .iOS("15.0"),
            infoPlist: "App/Info.plist",
            sources: ["App/**/*.swift"],
            resources: ["App/Resources/**"],
            dependencies: [
                .project(target: "AppFoundation", path: "../AppCore"),
                .project(target: "AppAuthImpl", path: "../AppFeature")
            ],
            settings: .settings(
                base: [:],
                configurations: [
                    .debug(name: "Debug", xcconfig: "Config/Test.xcconfig"),
                    .release(name: "Release", xcconfig: "Config/Prod.xcconfig")
                ]
            )
        )
    ]
)
