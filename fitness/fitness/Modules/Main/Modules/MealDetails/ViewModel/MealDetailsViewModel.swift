//
//  MealDetailsViewModel.swift
//  fitness
//
//  Created by Andrey Ushakov on 03.12.2024.
//

import Combine
import Foundation

final class MealDetailsViewModel {
    @Published private(set) var meal: Meal?
    private let mealID: String
    private let mealDataManager: MealDataManagerProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(mealID: String, mealDataManager: MealDataManagerProtocol) {
        self.mealID = mealID
        self.mealDataManager = mealDataManager
    }
    
    func fetchMealDetails() {
        mealDataManager.getMeal(by: mealID)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case let .failure(error) = completion {
                    print("Error fetching meal details: \(error.localizedDescription)")
                }
            } receiveValue: { [weak self] meal in
                self?.meal = meal
            }
            .store(in: &cancellables)
    }
}
