//
//  MealNetworkService.swift
//  fitness
//
//  Created by Andrey Ushakov on 02.12.2024.
//

import Foundation
import Combine
import FirebaseFirestore

protocol MealNetworkServiceProtocol {
    func getMealPlans(page: Int) -> AnyPublisher<[Meal], Error>
    func updateFavoriteStatus(for mealID: String, newFavoriteStatus: Bool) -> AnyPublisher<Void, Error>
}

final class MealNetworkService: MealNetworkServiceProtocol {
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func getMealPlans(page: Int) -> AnyPublisher<[Meal], Error> {
        networkService.fetchMeals(page: page)
    }
    
    func updateFavoriteStatus(for mealID: String, newFavoriteStatus: Bool) -> AnyPublisher<Void, Error> {
        Future { promise in
            let db = Firestore.firestore()
            let mealRef = db.collection("meals").document(mealID)
            mealRef.updateData(["mealIsFavorite": newFavoriteStatus]) { error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(()))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
