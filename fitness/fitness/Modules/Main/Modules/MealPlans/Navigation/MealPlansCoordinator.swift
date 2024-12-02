//
//  MealPlansCoordinator.swift
//  fitness
//
//  Created by Andrey Ushakov on 01.12.2024.
//

import UIKit

final class MealPlansCoordinator {
    private let navigationController: UINavigationController
    private let diContainer: DIContainer
    
    init(navigationController: UINavigationController, diContainer: DIContainer) {
        self.navigationController = navigationController
        self.diContainer = diContainer
    }
    
    func start() -> UIViewController {
        let viewModel = MealPlansViewModel(
            mealDataManager: diContainer.mealDataManager,
            router: self
        )
        let viewController = MealPlansViewController(viewModel: viewModel)
        return viewController
    }
}

extension MealPlansCoordinator: MealPlansRouter {
    func navigateToMealDetails(with mealID: String) {
        let detailsViewController = MealDetailsBuilder.build(mealID: mealID)
        navigationController.pushViewController(detailsViewController, animated: true)
    }
}
