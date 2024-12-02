//
//  DIContainer.swift
//  fitness
//
//  Created by Andrey Ushakov on 01.12.2024.
//

import Foundation

final class DIContainer {
    static let shared = DIContainer()
    
    private init() { }
    
    lazy var userDefaultsService: UserDefaultsServiceProtocol = UserDefaultsService()
    lazy var networkService: NetworkServiceProtocol = NetworkService()
    lazy var mealNetworkService: MealNetworkServiceProtocol = MealNetworkService(networkService: networkService)
    lazy var mealLocalDataService: MealLocalDataServiceProtocol = MealLocalDataService()
    lazy var mealDataManager: MealDataManagerProtocol = MealDataManager(
        networkService: mealNetworkService,
        localDataService: mealLocalDataService,
        userDefaultsService: userDefaultsService
    )
    lazy var imageCache: ImageCacheProtocol = ImageCache()
}
