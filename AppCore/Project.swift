import ProjectDescription

let appUtilsTarget: Target = .target(
    name: "AppUtils",
    destinations: [.iPhone, .iPad],
    product: .framework,
    bundleId: "com.bonjur.AppUtils",
    deploymentTargets: .iOS("15.0"),
    sources: ["AppUtils/**"],
    resources: [],
    dependencies: []
)

let DITarget: Target = .target(
    name: "DependecyInjection",
    destinations: [.iPhone, .iPad],
    product: .framework,
    bundleId: "com.bonjur.DependecyInjection",
    deploymentTargets: .iOS("15.0"),
    sources: ["DependecyInjection/**"],
    resources: [],
    dependencies: []
)

let appStorageTarget: Target = .target(
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
)

let appNetworkTarget: Target = .target(
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
)
    
let appFoundationTarget: Target = .target(
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
)
    
let appUIKitTarget: Target = .target(
    name: "AppUIKit",
    destinations: [.iPhone, .iPad],
    product: .framework,
    bundleId: "com.bonjur.AppUIKit",
    deploymentTargets: .iOS("15.0"),
    sources: ["AppUIKit/**"],
    resources: ["AppUIKit/**"],
    dependencies: []
)

let appLocalizationTarget: Target = .target(
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
    

let project = Project(
    name: "AppCore",
    options: .options(automaticSchemesOptions: .disabled),
    targets: [
        appUtilsTarget,
        DIarget,
        appStorageTarget,
        appNetworkTarget,
        appFoundationTarget,
        appUIKitTarget,
        appLocalizationTarget
    ],
    schemes: []
)
