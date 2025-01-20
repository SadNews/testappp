import ProjectDescription

let project = Project(
    name: "DI",
    targets: [
        .target(
            name: "DI",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.andreyushakov.fitness.DI",
            infoPlist: .default,
            sources: ["Sources/**"],
            resources: [],
            dependencies: [
                .project(target: "Core", path: "../Core")
            ]
        )
    ]
)
