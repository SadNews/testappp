//
//  DIContainer.swift
//  fitness
//
//  Created by Andrey Ushakov on 01.12.2024.
//

import Foundation
import Core

public final class DIContainer {
    public static let shared = DIContainer()
    
    private init() { }
    
    public lazy var userDefaultsService: UserDefaultsServiceProtocol = UserDefaultsService()
    public lazy var networkService: NetworkServiceProtocol = NetworkService()
    public lazy var mealNetworkService: MealNetworkServiceProtocol = MealNetworkService(networkService: networkService)
    public lazy var mealLocalDataService: MealLocalDataServiceProtocol = MealLocalDataService()
    public lazy var mealDataManager: MealDataManagerProtocol = MealDataManager(
        networkService: mealNetworkService,
        localDataService: mealLocalDataService,
        userDefaultsService: userDefaultsService
    )
    public lazy var imageCache: ImageCacheProtocol = ImageCache()
}
