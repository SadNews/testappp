//
//  MealEntity+Extensions.swift
//  fitness
//
//  Created by Andrey Ushakov on 02.12.2024.
//

import Foundation
import CoreData

extension MealEntity {
    func update(with meal: Meal) {
        self.id = meal.id
        self.mealName = meal.mealName
        self.mealDescription = meal.mealDescription
        self.mealCookTime = meal.mealCookTime
        self.mealCal = meal.mealCal
        self.mealIsFavorite = meal.mealIsFavorite ?? false
        self.mealIsRecommend = meal.mealIsRecommend ?? false
        self.recipeOfTheDay = meal.recipeOfTheDay
        self.mealCategory = meal.mealCategory
        self.mealImageUrl = meal.mealImageUrl
        self.mealVideoUrl = meal.mealVideoUrl
    }
    
    func toMeal() -> Meal {
        return Meal(
            id: self.id ?? "",
            mealName: self.mealName ?? "",
            mealDescription: self.mealDescription ?? "",
            mealCookTime: self.mealCookTime ?? "",
            mealCal: self.mealCal,
            mealIsFavorite: self.mealIsFavorite,
            mealIsRecommend: self.mealIsRecommend,
            recipeOfTheDay: self.recipeOfTheDay,
            mealCategory: self.mealCategory,
            mealImageUrl: self.mealImageUrl,
            mealVideoUrl: self.mealVideoUrl
        )
    }
}
