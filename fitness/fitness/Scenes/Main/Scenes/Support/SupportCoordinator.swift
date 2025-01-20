//
//  SupportCoordinator.swift
//  fitness
//
//  Created by Andrey Ushakov on 01.12.2024.
//

import UIKit

final class SupportCoordinator {
    let navigationController = UINavigationController()
    
    func start() {
        let viewModel = SupportViewModel()
        let viewController = SupportViewController(viewModel: viewModel)
        viewModel.coordinator = self
        navigationController.viewControllers = [viewController]
    }
}
