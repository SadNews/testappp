//
//  UserDefaultsService.swift
//  fitness
//
//  Created by Andrey Ushakov on 01.12.2024.
//

import Foundation

enum UserDefaultsServiceKey: String {
    case hasMealPlan
    case isFirstLaunch
}

protocol UserDefaultsServiceProtocol {
    func setValue<T: Codable>(_ value: T, for key: UserDefaultsServiceKey)
    func getValue<T: Codable>(for key: UserDefaultsServiceKey) -> T?
    func remove(for key: UserDefaultsServiceKey)
}

final class UserDefaultsService: UserDefaultsServiceProtocol {
    private let userDefaults = UserDefaults()
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    func setValue<T: Codable>(_ value: T, for key: UserDefaultsServiceKey) {
        guard let encoded = try? encoder.encode(value) else { return }
        userDefaults.setValue(encoded, forKey: key.rawValue)
    }
    
    func getValue<T: Codable>(for key: UserDefaultsServiceKey) -> T? {
        guard let data = userDefaults.object(forKey: key.rawValue) as? Data else {
            return nil
        }
        
        return try? decoder.decode(T.self, from: data)
    }
    
    func remove(for key: UserDefaultsServiceKey) {
        userDefaults.removeObject(forKey: key.rawValue)
    }
}
