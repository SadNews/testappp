//
//  MealLocalDataService.swift
//  fitness
//
//  Created by Andrey Ushakov on 02.12.2024.
//

import Foundation
import Combine
import CoreData

protocol MealLocalDataServiceProtocol {
    func fetchMeals(page: Int) -> AnyPublisher<[Meal], Error>
    func saveMeals(_ meals: [Meal])
    func updateFavoriteStatus(for mealID: String, newFavoriteStatus: Bool) -> AnyPublisher<Void, Error>
    func fetchMeal(by id: String) -> AnyPublisher<Meal, Error>
}

final class MealLocalDataService: MealLocalDataServiceProtocol {
    private let context: NSManagedObjectContext
    private let itemsPerPage = 20
    
    init(context: NSManagedObjectContext = CoreDataStack.shared.context) {
        self.context = context
    }
    
    func fetchMeals(page: Int) -> AnyPublisher<[Meal], Error> {
        let fetchRequest: NSFetchRequest<MealEntity> = MealEntity.fetchRequest()
        fetchRequest.fetchLimit = itemsPerPage
        fetchRequest.fetchOffset = (page - 1) * itemsPerPage
        
        return Future { [weak self] promise in
            do {
                let mealEntities = try self?.context.fetch(fetchRequest) ?? []
                let meals = mealEntities.map { $0.toMeal() }
                promise(.success(meals))
            } catch {
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }
    
    func saveMeals(_ meals: [Meal]) {
        context.perform {
            for meal in meals {
                let mealEntity = MealEntity(context: self.context)
                mealEntity.update(with: meal)
            }
            do {
                try self.context.save()
            } catch {
                print("Ошибка сохранения в Core Data: \(error)")
            }
        }
    }
    
    func updateFavoriteStatus(for mealID: String, newFavoriteStatus: Bool) -> AnyPublisher<Void, Error> {
        Future { [weak self] promise in
            guard let self = self else { return }
            self.context.perform {
                let fetchRequest: NSFetchRequest<MealEntity> = MealEntity.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "id == %@", mealID)
                do {
                    if let mealEntity = try self.context.fetch(fetchRequest).first {
                        mealEntity.mealIsFavorite = newFavoriteStatus
                        try self.context.save()
                        promise(.success(()))
                    } else {
                        promise(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Meal not found"])))
                    }
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func fetchMeal(by id: String) -> AnyPublisher<Meal, Error> {
        Future { [weak self] promise in
            guard let self = self else {
                promise(.failure(MyError.selfIsNil))
                return
            }
            self.context.perform {
                let fetchRequest: NSFetchRequest<MealEntity> = MealEntity.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "id == %@", id)
                do {
                    if let mealEntity = try self.context.fetch(fetchRequest).first {
                        let meal = mealEntity.toMeal()
                        promise(.success(meal))
                    } else {
                        promise(.failure(MyError.mealNotFound))
                    }
                } catch {
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
}
