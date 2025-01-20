//
//  UserDefaultsService.swift
//  fitness
//
//  Created by Andrey Ushakov on 01.12.2024.
//

import Foundation

public enum UserDefaultsServiceKey: String {
    case hasMealPlan
    case isFirstLaunch
}

public protocol UserDefaultsServiceProtocol {
    func setValue<T: Codable>(_ value: T, for key: UserDefaultsServiceKey)
    func getValue<T: Codable>(for key: UserDefaultsServiceKey) -> T?
    func remove(for key: UserDefaultsServiceKey)
}

public final class UserDefaultsService: UserDefaultsServiceProtocol {
    private let userDefaults = UserDefaults()
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    public init() { }
    
    public func setValue<T: Codable>(_ value: T, for key: UserDefaultsServiceKey) {
        guard let encoded = try? encoder.encode(value) else { return }
        userDefaults.setValue(encoded, forKey: key.rawValue)
    }
    
    public func getValue<T: Codable>(for key: UserDefaultsServiceKey) -> T? {
        guard let data = userDefaults.object(forKey: key.rawValue) as? Data else {
            return nil
        }
        
        return try? decoder.decode(T.self, from: data)
    }
    
    public func remove(for key: UserDefaultsServiceKey) {
        userDefaults.removeObject(forKey: key.rawValue)
    }
}
