//
//  MealDetailsBuilder.swift
//  fitness
//
//  Created by Andrey Ushakov on 03.12.2024.
//

import UIKit
import DI

protocol MealDetailsBuilderProtocol {
    static func build(mealID: String) -> UIViewController
}

enum MealDetailsBuilder: MealDetailsBuilderProtocol {
    static func build(mealID: String) -> UIViewController {
        let viewModel = MealDetailsViewModel(mealID: mealID, mealDataManager: DIContainer.shared.mealDataManager)
        return MealDetailsViewController(viewModel: viewModel)
    }
}
