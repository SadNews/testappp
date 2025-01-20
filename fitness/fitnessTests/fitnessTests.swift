//
//  fitnessTests.swift
//  fitnessTests
//
//  Created by Andrey Ushakov on 19.01.2025.
//

import Testing

import XCTest
import Combine
@testable import Fitness

final class MealPlansViewModelTests: XCTestCase {
    
    private var viewModel: MealPlansViewModel!
    private var mockDataManager: MockMealDataManager!
    private var mockRouter: MockMealPlansRouter!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockDataManager = MockMealDataManager()
        mockRouter = MockMealPlansRouter()
        viewModel = MealPlansViewModel(mealDataManager: mockDataManager, router: mockRouter)
        cancellables = []
    }
    
    override func tearDown() {
        viewModel = nil
        mockDataManager = nil
        mockRouter = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testFetchMeals_Success() {
        // Given
        let meals = [
            Meal(id: "1", mealName: "Meal 1", mealDescription: "Description 1", mealCookTime: "10 min", mealCal: "200", mealIsFavorite: false, mealIsRecommend: false, recipeOfTheDay: true, mealCategory: nil, mealImageUrl: nil, mealVideoUrl: nil),
            Meal(id: "2", mealName: "Meal 2", mealDescription: "Description 2", mealCookTime: "15 min", mealCal: "250", mealIsFavorite: true, mealIsRecommend: true, recipeOfTheDay: false, mealCategory: nil, mealImageUrl: nil, mealVideoUrl: nil),
            Meal(id: "3", mealName: "Meal 3", mealDescription: "Description 3", mealCookTime: "20 min", mealCal: "300", mealIsFavorite: false, mealIsRecommend: false, recipeOfTheDay: false, mealCategory: nil, mealImageUrl: nil, mealVideoUrl: nil)

        ]
        mockDataManager.stubbedMeals = meals
        
        let expectation = XCTestExpectation(description: "Snapshot updated")
        
        viewModel.$snapshot
            .dropFirst()
            .sink { snapshot in
                XCTAssertEqual(snapshot.numberOfSections, 3)
                XCTAssertEqual(snapshot.itemIdentifiers(inSection: .recipeOfTheDay), [meals[0]])
                XCTAssertEqual(snapshot.itemIdentifiers(inSection: .recommended), [meals[1]])
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.fetchMeals(page: 1)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testFetchMeals_Failure() {
        let error = NSError(domain: "TestError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch meals"])
        mockDataManager.stubbedError = error
        
        let expectation = XCTestExpectation(description: "Error message updated")
        
        viewModel.$errorMessage
            .dropFirst()
            .sink { errorMessage in
                XCTAssertEqual(errorMessage, "Failed to fetch meals")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.fetchMeals(page: 1)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
   
    func testToggleFavorite_Success() {
        let meal = Meal(id: "1", mealName: "Meal 1", mealDescription: "Description 1", mealCookTime: "10 min", mealCal: "200", mealIsFavorite: false, mealIsRecommend: false, recipeOfTheDay: false, mealCategory: nil, mealImageUrl: nil, mealVideoUrl: nil)
        let updatedMeal = Meal(id: "1", mealName: "Meal 1", mealDescription: "Description 1", mealCookTime: "10 min", mealCal: "200", mealIsFavorite: true, mealIsRecommend: false, recipeOfTheDay: false, mealCategory: nil, mealImageUrl: nil, mealVideoUrl: nil)
        
        mockDataManager.stubbedMeals = [meal]
        mockDataManager.stubbedUpdatedMeal = updatedMeal
        
        let expectation = XCTestExpectation(description: "Meals updated")
        
        viewModel.$snapshot
            .dropFirst()
            .sink { snapshot in
                let resultMeal = snapshot.itemIdentifiers.first
                XCTAssertEqual(resultMeal?.mealIsFavorite, true)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.fetchMeals(page: 1)
        viewModel.toggleFavorite(for: meal)
        
        wait(for: [expectation], timeout: 1.0)
    }

    func testToggleFavorite_Failure() {
        let meal = Meal(id: "1", mealName: "Meal 1", mealDescription: "Description 1", mealCookTime: "10 min", mealCal: "200", mealIsFavorite: false, mealIsRecommend: false, recipeOfTheDay: false, mealCategory: nil, mealImageUrl: nil, mealVideoUrl: nil)
        let error = NSError(domain: "TestError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to update favorite status"])
        mockDataManager.stubbedError = error
        
        let expectation = XCTestExpectation(description: "Error message updated")
        
        viewModel.$errorMessage
            .dropFirst()
            .sink { errorMessage in
                XCTAssertEqual(errorMessage, "Failed to update favorite status")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.toggleFavorite(for: meal)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testDidSelectMeal() {
        let mealID = "123"
        
        viewModel.didSelectMeal(with: mealID)
        
        XCTAssertEqual(mockRouter.capturedMealID, mealID)
    }
}

// MARK: - Mocks

final class MockMealDataManager: MealDataManagerProtocol {
    var stubbedMeals: [Meal] = []
    var stubbedUpdatedMeal: Meal?
    var stubbedError: Error?
    
    func getMeals(page: Int) -> AnyPublisher<[Meal], Error> {
        if let error = stubbedError {
            return Fail(error: error).eraseToAnyPublisher()
        }
        return Just(stubbedMeals)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func getMeal(by id: String) -> AnyPublisher<Meal, Error> {
        // Not used in tests
        fatalError("Not implemented")
    }
    
    func updateFavoriteStatus(for mealID: String, newFavoriteStatus: Bool) -> AnyPublisher<Meal, Error> {
        if let error = stubbedError {
            return Fail(error: error).eraseToAnyPublisher()
        }
        guard let updatedMeal = stubbedUpdatedMeal else {
            return Fail(error: NSError(domain: "TestError", code: 0, userInfo: nil)).eraseToAnyPublisher()
        }
        return Just(updatedMeal)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}

final class MockMealPlansRouter: MealPlansRouter {
    var capturedMealID: String?
    
    func navigateToMealDetails(with mealID: String) {
        capturedMealID = mealID
    }
}
