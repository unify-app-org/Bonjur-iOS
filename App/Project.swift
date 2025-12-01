import ProjectDescription

let projectSettings: Settings = .settings(
    base: [:],
    configurations: [
        .debug(name: "Debug", xcconfig: "Config/Test.xcconfig"),
        .release(name: "Release", xcconfig: "Config/Prod.xcconfig"),
        .release(name: "Staging", xcconfig: "Config/Staging.xcconfig")
    ]
)

let appTarget: Target = .target(
    name: "App",
    destinations: [.iPhone, .iPad],
    product: .app,
    bundleId: "com.bonjur.app",
    deploymentTargets: .iOS("15.0"),
    infoPlist: "App/Info.plist",
    sources: ["App/**/*.swift"],
    resources: ["App/Resources/**"],
    dependencies: [
        // Core
        .project(target: "AppFoundation", path: "../AppCore"),
        .project(target: "AppStorage", path: "../AppCore"),
        .project(target: "AppNetwork", path: "../AppCore"),
        .project(target: "AppLocalization", path: "../AppCore"),
        .project(target: "AppUIKit", path: "../AppCore"),
        // Feature
        .project(target: "AppAuth", path: "../AppFeature"),
        .project(target: "AppAuthImpl", path: "../AppFeature")
    ],
    settings: projectSettings
)

let prodScheme: Scheme = .scheme(
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

let testScheme: Scheme = .scheme(
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
)

let stagingScheme: Scheme = .scheme(
    name: "Bonjur-Staging",
    shared: true,
    buildAction: .buildAction(
        targets: ["App"]
    ),
    testAction: .targets(
        ["App"],
        configuration: "Staging"
    ),
    runAction: .runAction(
        configuration: "Staging"
    ),
    archiveAction: .archiveAction(
        configuration: "Staging"
    ),
    profileAction: .profileAction(
        configuration: "Staging"
    )
)

let project = Project(
    name: "App",
    organizationName: "Bonjur",
    options: .options(automaticSchemesOptions: .disabled),
    settings: projectSettings,
    targets: [appTarget],
    schemes: [
        testScheme,
        prodScheme,
        stagingScheme
    ]
)
