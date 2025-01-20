import ProjectDescription

let project = Project(
    name: "CoreUI",
    targets: [
        .target(
            name: "CoreUI",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.andreyushakov.fitness.coreui",
            infoPlist: .default,
            sources: ["Sources/**"],
            resources: ["Resources/**"]
        )
    ]
)
