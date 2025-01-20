//
//  MealIdeasBuilder.swift
//  fitness
//
//  Created by Andrey Ushakov on 01.12.2024.
//

import UIKit

protocol MealIdeasBuilderProtocol {
    static func build(navigationController: UINavigationController) -> MealIdeasCoordinator
}

enum MealIdeasBuilder: MealIdeasBuilderProtocol {
    static func build(navigationController: UINavigationController) -> MealIdeasCoordinator {
        let coordinator = MealIdeasCoordinator(
            navigationController: navigationController)
        return coordinator
    }
}
