//
//  CoreDataStack.swift
//  fitness
//
//  Created by Andrey Ushakov on 02.12.2024.
//

import Foundation
import CoreData

public final class CoreDataStack {
    public static let shared = CoreDataStack()
    
    public init() { }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataModels")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Не удалось загрузить хранилище Core Data: \(error)")
            }
        }
        return container
    }()
    
    public var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
}
