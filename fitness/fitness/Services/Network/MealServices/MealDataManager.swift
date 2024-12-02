//
//  MealDataManager.swift
//  fitness
//
//  Created by Andrey Ushakov on 02.12.2024.
//

import Foundation
import Combine

protocol MealDataManagerProtocol {
    func getMeals(page: Int) -> AnyPublisher<[Meal], Error>
    func getMeal(by id: String) -> AnyPublisher<Meal, Error>
    func updateFavoriteStatus(for mealID: String, newFavoriteStatus: Bool) -> AnyPublisher<Meal, Error>
}

final class MealDataManager: MealDataManagerProtocol {
    private let networkService: MealNetworkServiceProtocol
    private let localDataService: MealLocalDataServiceProtocol
    private let userDefaultsService: UserDefaultsServiceProtocol
    
    init(networkService: MealNetworkServiceProtocol,
         localDataService: MealLocalDataServiceProtocol,
         userDefaultsService: UserDefaultsServiceProtocol) {
        self.networkService = networkService
        self.localDataService = localDataService
        self.userDefaultsService = userDefaultsService
    }
    
    func getMeals(page: Int) -> AnyPublisher<[Meal], Error> {
//        let isFirstLaunch: Bool = userDefaultsService.getValue(for: .isFirstLaunch) ?? true 
        let isFirstLaunch: Bool = true

        if isFirstLaunch {
            return networkService.getMealPlans(page: page)
                .handleEvents(receiveOutput: { [weak self] meals in
                    self?.localDataService.saveMeals(meals)
                    self?.userDefaultsService.setValue(false, for: .isFirstLaunch)
                })
                .eraseToAnyPublisher()
        } else {
            return localDataService.fetchMeals(page: page)
        }
    }
    
    func updateFavoriteStatus(for mealID: String, newFavoriteStatus: Bool) -> AnyPublisher<Meal, Error> {
        return networkService.updateFavoriteStatus(for: mealID, newFavoriteStatus: newFavoriteStatus)
            .flatMap { [weak self] _ -> AnyPublisher<Meal, Error> in
                guard let self = self else {
                    return Fail(error: MyError.selfIsNil).eraseToAnyPublisher()
                }
                return self.localDataService.updateFavoriteStatus(for: mealID, newFavoriteStatus: newFavoriteStatus)
                    .flatMap { _ in
                        self.localDataService.fetchMeal(by: mealID)
                    }
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    func getMeal(by id: String) -> AnyPublisher<Meal, Error> {
        localDataService.fetchMeal(by: id)
            .catch { [weak self] _ -> AnyPublisher<Meal, Error> in
                guard let self = self else {
                    return Fail(error: MyError.selfIsNil).eraseToAnyPublisher()
                }
                return self.networkService.getMealPlans(page: 1)
                    .map { meals -> Meal? in
                        meals.first { $0.id == id }
                    }
                    .flatMap { meal -> AnyPublisher<Meal, Error> in
                        guard let meal = meal else {
                            return Fail(error: MyError.mealNotFound).eraseToAnyPublisher()
                        }
                        self.localDataService.saveMeals([meal])
                        return Just(meal)
                            .setFailureType(to: Error.self)
                            .eraseToAnyPublisher()
                    }
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}

enum MyError: Error {
    case selfIsNil
    case mealNotFound

}
