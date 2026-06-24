//
//  Project.swift
//  Manifests
//
//  Created by Huseyn Hasanov
//

import ProjectDescription
import ProjectDescriptionHelpers

let appTarget: Target = .target(
    name: "App",
    destinations: [.iPhone],
    product: .app,
    bundleId: "$(BUNDLE_ID)",
    deploymentTargets: .iOS(Project.deploymentTarget),
    infoPlist: "App/Info.plist",
    sources: ["App/**/*.swift"],
    resources: ["App/Resources/**"],
    entitlements: "App/App.entitlements",
    scripts: [
        .post(
            script: """
            ENV_CAP="$(echo "${ENVIRONMENT}" | awk '{print toupper(substr($0,1,1)) substr($0,2)}')"
            SRC="${SRCROOT}/App/Resources/Firebase/GoogleService-Info-${ENV_CAP}.plist"
            DST="${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/GoogleService-Info.plist"
            if [ -f "${SRC}" ]; then
                cp "${SRC}" "${DST}"
                echo "Firebase: copied ${SRC} -> ${DST}"
            else
                echo "warning: Firebase plist not found at ${SRC}"
            fi
            """,
            name: "Firebase: select GoogleService-Info plist",
            basedOnDependencyAnalysis: false
        ),
        .post(
            script: """
            RUN_SCRIPT="${BUILD_DIR%/Build/*}/SourcePackages/checkouts/firebase-ios-sdk/Crashlytics/run"
            if [ ! -f "$RUN_SCRIPT" ]; then
                RUN_SCRIPT="${SRCROOT}/../.build/checkouts/firebase-ios-sdk/Crashlytics/run"
            fi
            "$RUN_SCRIPT"
            """,
            name: "Firebase Crashlytics Upload Symbols",
            inputPaths: [
                "${DWARF_DSYM_FOLDER_PATH}/${DWARF_DSYM_FILE_NAME}/Contents/Resources/DWARF/${TARGET_NAME}",
                "$(SRCROOT)/$(BUILT_PRODUCTS_DIR)/$(INFOPLIST_PATH)"
            ],
            runForInstallBuildsOnly: true
        )
    ],
    dependencies: TargetDependency.AllDependencies,
    settings: .settings(base: .mainTargetBuildSettings)
)

let project = Project(
    name: Project.Projects.main,
    organizationName: Project.organizationName,
    options: .options(automaticSchemesOptions: .disabled),
    settings: .settings(base: .default, configurations: .default),
    targets: [appTarget],
    schemes: [
        .testScheme,
        .prodScheme,
        .stagingScheme
    ]
)
