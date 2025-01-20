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
            resources: ["fitness/Resources/**"],
            dependencies: [
                .package(product: "FirebaseFirestore")
            ]
        ),
        .target(
            name: "FitnessTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.andreyushakov.fitness.tests",
            infoPlist: .default,
            sources: ["fitnessTests/**"],
            resources: [],
            dependencies: [.target(name: "Fitness")]
        )
    ]
)
