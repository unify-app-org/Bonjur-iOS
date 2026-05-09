// swift-tools-version: 5.9
@preconcurrency import PackageDescription

#if TUIST
import ProjectDescriptionHelpers
import ProjectDescription

let packageSettings = PackageSettings(
    productTypes: [
        "MSAL": .framework
    ]
)
#endif

let package = Package(
    name: "AppDependencies",
    dependencies: [
        .package(
            url: "https://github.com/AzureAD/microsoft-authentication-library-for-objc",
            .upToNextMajor(from: "1.4.0")
        )
    ]
)
