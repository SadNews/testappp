import ProjectDescription

let project = Project(
    name: "Fitness",
    packages: [
        .remote(
            url: "https://github.com/firebase/firebase-ios-sdk.git",
            requirement: .upToNextMajor(from: "10.7.0")
        )
    ],
    targets: [
        .target(
            name: "Fitness",
            destinations: .iOS,
            product: .app,
            bundleId: "com.andreyushakov.fitness",
            infoPlist: .extendingDefault(
                with: [
                    "UIApplicationSceneManifest": [
                        "UIApplicationSupportsMultipleScenes": false
                    ],
                    "UILaunchStoryboardName": "",
                    "FirebaseAppDelegateProxyEnabled": false 
                ]
            ),
            sources: ["fitness/**"],
            resources: [],
            dependencies: [
                .project(target: "MealPlans", path: "../Modules/MealPlans"),
                .project(target: "Core", path: "../Modules/Core"),
                .project(target: "CoreUI", path: "../Modules/CoreUI")
            ]
        )
    ]
)

