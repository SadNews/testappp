//
//  NetworkService.swift
//  fitness
//
//  Created by Andrey Ushakov on 02.12.2024.
//

import Foundation
import Combine
import FirebaseFirestore

protocol NetworkServiceProtocol {
    func fetchMeals(page: Int) -> AnyPublisher<[Meal], Error>
}

final class NetworkService: NetworkServiceProtocol {
    private let db = Firestore.firestore()
    private let mealsCollection = "meals"
    private let itemsPerPage = 20
    
    func fetchMeals(page: Int) -> AnyPublisher<[Meal], Error> {
        let publisher = PassthroughSubject<[Meal], Error>()
        
        let query = db.collection(mealsCollection)
            .order(by: "id")
            .limit(to: itemsPerPage)
            .start(at: [(page - 1) * itemsPerPage])
        
        query.getDocuments { snapshot, error in
            if let error = error {
                publisher.send(completion: .failure(error))
            } else if let snapshot = snapshot {
                let meals = snapshot.documents.compactMap { document -> Meal? in
                    try? document.data(as: Meal.self)
                }
                publisher.send(meals)
                publisher.send(completion: .finished)
            }
        }
        
        return publisher.eraseToAnyPublisher()
    }
}
