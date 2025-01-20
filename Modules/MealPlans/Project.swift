import ProjectDescription

let project = Project(
    name: "MealPlans",
    targets: [
        .target(
            name: "MealPlans",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.andreyushakov.fitness.mealplans",
            infoPlist: .default,
            sources: ["Sources/**"],
            resources: [],
            dependencies: [
                .project(target: "Core", path: "../Core"),
                .project(target: "CoreUI", path: "../CoreUI"),
                .project(target: "DI", path: "../DI")
            ]
        )
    ]
)
