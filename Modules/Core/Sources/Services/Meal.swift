//
//  Meal.swift
//  fitness
//
//  Created by Andrey Ushakov on 02.12.2024.
//

import Foundation

public struct Meal: Codable, Identifiable, Hashable {
    public let id: String
    public let mealName: String
    public let mealDescription: String
    public let mealCookTime: String
    public let mealCal: String?
    public let mealIsFavorite: Bool?
    public let mealIsRecommend: Bool?
    public let recipeOfTheDay: Bool
    public let mealCategory: String?
    public let mealImageUrl: String?
    public let mealVideoUrl: String?
}
