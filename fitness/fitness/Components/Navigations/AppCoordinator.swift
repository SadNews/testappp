//
//  AppCoordinator.swift
//  fitness
//
//  Created by Andrey Ushakov on 01.12.2024.
//

import UIKit

class AppCoordinator {
    private let window: UIWindow
    private var navigationController: UINavigationController?
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        showSplashScreen()
    }
    
    private func showSplashScreen() {
        let splashViewController = SplashViewController()
        window.rootViewController = splashViewController
        window.makeKeyAndVisible()
        
        // Имитация задержки для Splash Screen
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.showMainScreen()
        }
    }
    
    private func showMainScreen() {
        let mainTabBarController = MainTabBarController()
        window.rootViewController = mainTabBarController
    }
}
