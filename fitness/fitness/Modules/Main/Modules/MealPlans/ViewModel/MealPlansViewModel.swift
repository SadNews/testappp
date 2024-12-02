//
//  MealPlansViewModel.swift
//  fitness
//
//  Created by Andrey Ushakov on 01.12.2024.
//

import Combine
import UIKit

final class MealPlansViewModel {
    private let mealDataManager: MealDataManagerProtocol
    private let router: MealPlansRouter
    private var cancellables = Set<AnyCancellable>()
    
    @Published var snapshot = NSDiffableDataSourceSnapshot<MealPlansViewController.Section, Meal>()
    @Published var errorMessage: String?
    
    private(set) var meals: [Meal] = [] {
        didSet {
            updateSnapshot()
        }
    }
    
    var recipeOfTheDayMeals: [Meal] {
        meals.filter { $0.recipeOfTheDay }
    }
    
    var recommendedMeals: [Meal] {
        meals.filter { $0.mealIsRecommend == true }
    }
    
    var otherMeals: [Meal] {
        meals.filter { !$0.recipeOfTheDay && $0.mealIsRecommend != true }
    }
    
    init(mealDataManager: MealDataManagerProtocol, router: MealPlansRouter) {
        self.mealDataManager = mealDataManager
        self.router = router
    }
    
    func fetchMeals(page: Int) {
        mealDataManager.getMeals(page: page)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] meals in
                self?.meals = meals
            }
            .store(in: &cancellables)
    }
    
    func toggleFavorite(for meal: Meal) {
        let newFavoriteStatus = !(meal.mealIsFavorite ?? false)
        mealDataManager.updateFavoriteStatus(for: meal.id, newFavoriteStatus: newFavoriteStatus)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] updatedMeal in
                if let index = self?.meals.firstIndex(where: { $0.id == updatedMeal.id }) {
                    self?.meals[index] = updatedMeal
                }
            }
            .store(in: &cancellables)
    }
    
    private func updateSnapshot() {
        var newSnapshot = NSDiffableDataSourceSnapshot<MealPlansViewController.Section, Meal>()
        
        if !recipeOfTheDayMeals.isEmpty {
            newSnapshot.appendSections([.recipeOfTheDay])
            newSnapshot.appendItems(recipeOfTheDayMeals, toSection: .recipeOfTheDay)
        }
        
        if !recommendedMeals.isEmpty {
            newSnapshot.appendSections([.recommended])
            newSnapshot.appendItems(recommendedMeals, toSection: .recommended)
        }
        
        if !otherMeals.isEmpty {
            newSnapshot.appendSections([.recipesForYou])
            newSnapshot.appendItems(otherMeals, toSection: .recipesForYou)
        }
        
        snapshot = newSnapshot
    }
    
    func didSelectMeal(with mealID: String) {
        router.navigateToMealDetails(with: mealID)
    }
}
