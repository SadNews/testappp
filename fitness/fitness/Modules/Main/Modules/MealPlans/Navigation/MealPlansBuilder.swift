//
//  MealPlansBuilder.swift
//  fitness
//
//  Created by Andrey Ushakov on 01.12.2024.
//

import UIKit

protocol MealPlansBuilderProtocol {
    static func build(navigationController: UINavigationController) -> MealPlansCoordinator
}

enum MealPlansBuilder: MealPlansBuilderProtocol {
    static func build(navigationController: UINavigationController) -> MealPlansCoordinator {
        let diContainer = DIContainer.shared
        let coordinator = MealPlansCoordinator(
            navigationController: navigationController,
            diContainer: diContainer
        )
        return coordinator
    }
}
