//
//  Meal.swift
//  fitness
//
//  Created by Andrey Ushakov on 02.12.2024.
//

import Foundation

struct Meal: Codable, Identifiable, Hashable {
    let id: String
    let mealName: String
    let mealDescription: String
    let mealCookTime: String
    let mealCal: String?
    let mealIsFavorite: Bool?
    let mealIsRecommend: Bool?
    let recipeOfTheDay: Bool
    let mealCategory: String?
    let mealImageUrl: String?
    let mealVideoUrl: String?
}
