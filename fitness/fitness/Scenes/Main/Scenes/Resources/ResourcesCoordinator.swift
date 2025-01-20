//
//  ResourcesCoordinator.swift
//  fitness
//
//  Created by Andrey Ushakov on 01.12.2024.
//

import UIKit

final class ResourcesCoordinator {
    let navigationController = UINavigationController()
    
    func start() {
        let viewModel = ResourcesViewModel()
        let viewController = ResourcesViewController(viewModel: viewModel)
        viewModel.coordinator = self
        navigationController.viewControllers = [viewController]
    }
}
