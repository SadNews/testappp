//
//  HomeCoordinator.swift
//  fitness
//
//  Created by Andrey Ushakov on 01.12.2024.
//

import UIKit

final class HomeCoordinator {
    let navigationController = UINavigationController()
    
    func start() {
        let viewModel = HomeViewModel()
        let viewController = HomeViewController(viewModel: viewModel)
        viewModel.coordinator = self
        navigationController.viewControllers = [viewController]
    }
    
    func showNutritionScreen() {
        let nutritionCoordinator = NutritionCoordinator(navigationController: navigationController)
        nutritionCoordinator.start()
    }
}
