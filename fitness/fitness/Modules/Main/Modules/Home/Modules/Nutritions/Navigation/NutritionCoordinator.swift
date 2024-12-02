//
//  NutritionCoordinator.swift
//  fitness
//
//  Created by Andrey Ushakov on 01.12.2024.
//

import UIKit

final class NutritionCoordinator {
    private let navigationController: UINavigationController
    private var mealPlansCoordinator: MealPlansCoordinator?
    private var mealIdeasCoordinator: MealIdeasCoordinator?
    private weak var nutritionViewController: NutritionViewController?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = NutritionViewModel(router: self)
        let viewController = NutritionViewController(viewModel: viewModel)
        self.nutritionViewController = viewController
        navigationController.pushViewController(viewController, animated: true)
        
        showMealPlans()
    }
}

extension NutritionCoordinator: NutritionRouter {
    func showMealPlans() {
        nutritionViewController?.removeCurrentContentController()
            mealPlansCoordinator = MealPlansBuilder.build(navigationController: navigationController)
        
        if let mealPlansViewController = mealPlansCoordinator?.start() {
            nutritionViewController?.displayContentController(mealPlansViewController)
        }
    }
    
    func showMealIdeas() {
        nutritionViewController?.removeCurrentContentController()
        mealIdeasCoordinator = MealIdeasBuilder.build(navigationController: navigationController)
        
        if let mealIdeasViewController = mealIdeasCoordinator?.start() {
            nutritionViewController?.displayContentController(mealIdeasViewController)
        }
    }
}
