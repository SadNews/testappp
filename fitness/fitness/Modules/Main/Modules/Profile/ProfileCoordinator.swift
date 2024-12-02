//
//  ProfileCoordinator.swift
//  fitness
//
//  Created by Andrey Ushakov on 01.12.2024.
//

import UIKit

final class ProfileCoordinator {
    let navigationController = UINavigationController()
    
    func start() {
        let viewModel = ProfileViewModel()
        let viewController = ProfileViewController(viewModel: viewModel)
        viewModel.coordinator = self
        navigationController.viewControllers = [viewController]
    }
}
