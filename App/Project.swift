import ProjectDescription

let appTarget: Target =  .target(
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
    

let project = Project(
    name: "App",
    organizationName: "Bonjur",
    options: .options(automaticSchemesOptions: .disabled),
    targets: [appTarget],
    schemes: [
        .scheme(
            name: "Bonjur-Test",
            shared: true,
            buildAction: .buildAction(
                targets: ["App"]
            ),
            testAction: .targets(
                ["App"],
                configuration: "Debug"
            ),
            runAction: .runAction(
                configuration: "Debug"
            ),
            archiveAction: .archiveAction(
                configuration: "Debug"
            ),
            profileAction: .profileAction(
                configuration: "Debug"
            )
        ),
        .scheme(
            name: "Bonjur-Release",
            shared: true,
            buildAction: .buildAction(
                targets: ["App"]
            ),
            testAction: .targets(
                ["App"],
                configuration: "Release"
            ),
            runAction: .runAction(
                configuration: "Release"
            ),
            archiveAction: .archiveAction(
                configuration: "Release"
            ),
            profileAction: .profileAction(
                configuration: "Release"
            )
        )
    ]
)
