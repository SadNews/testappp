//
//  MainTabBarController.swift
//  fitness
//
//  Created by Andrey Ushakov on 01.12.2024.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    private let homeCoordinator = HomeCoordinator()
    private let resourcesCoordinator = ResourcesCoordinator()
    private let profileCoordinator = ProfileCoordinator()
    private let supportCoordinator = SupportCoordinator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBarAppearance()
        
        setupCoordinators()
        
        viewControllers = [
            homeCoordinator.navigationController,
            resourcesCoordinator.navigationController,
            profileCoordinator.navigationController,
            supportCoordinator.navigationController
        ]
        
        setupTabBarItems()
    }
    
    private func setupCoordinators() {
        homeCoordinator.start()
        resourcesCoordinator.start()
        profileCoordinator.start()
        supportCoordinator.start()
    }
    
    private func setupTabBarAppearance() {
        if #available(iOS 13.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .appLightPurple
            
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.clear]
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.clear]
            
            appearance.stackedLayoutAppearance.normal.iconColor = .white
            appearance.stackedLayoutAppearance.selected.iconColor = .white

            tabBar.standardAppearance = appearance
            
            if #available(iOS 15.0, *) {
                tabBar.scrollEdgeAppearance = appearance
            }
        } else {
            tabBar.barTintColor = .appLightPurple
            tabBar.isTranslucent = false
            tabBar.tintColor = .white
            tabBar.unselectedItemTintColor = .white
        }
    }

    
    private func setupTabBarItems() {
        homeCoordinator.navigationController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(resource: .homeTabbarIcon).withRenderingMode(.alwaysTemplate),
            tag: 0
        )
        resourcesCoordinator.navigationController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(resource: .resourcesTabbarIcon).withRenderingMode(.alwaysTemplate),
            tag: 1
        )
        profileCoordinator.navigationController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(resource: .starsTabbarIcon).withRenderingMode(.alwaysTemplate),
            tag: 2
        )
        supportCoordinator.navigationController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(resource: .supportTabbarIcon).withRenderingMode(.alwaysTemplate),
            tag: 3
        )
        
        let tabBarItems: [UITabBarItem] = [
            homeCoordinator.navigationController.tabBarItem,
            resourcesCoordinator.navigationController.tabBarItem,
            profileCoordinator.navigationController.tabBarItem,
            supportCoordinator.navigationController.tabBarItem
        ]
        
        tabBarItems.forEach { item in
            item.title = nil
            item.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        }
    }
}
