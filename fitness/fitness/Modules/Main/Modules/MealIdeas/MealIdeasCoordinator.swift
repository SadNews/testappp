//
//  MealIdeasCoordinator.swift
//  fitness
//
//  Created by Andrey Ushakov on 01.12.2024.
//

import UIKit

final class MealIdeasCoordinator {
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() -> UIViewController {
        let viewModel = MealIdeasViewModel()
        let viewController = MealIdeasViewController(viewModel: viewModel)
        return viewController
    }
}

