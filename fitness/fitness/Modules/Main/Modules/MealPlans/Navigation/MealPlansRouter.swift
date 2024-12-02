//
//  MealPlansRouter.swift
//  fitness
//
//  Created by Andrey Ushakov on 01.12.2024.
//

import Foundation

protocol MealPlansRouter: AnyObject {
    func navigateToMealDetails(with mealID: String)
}
