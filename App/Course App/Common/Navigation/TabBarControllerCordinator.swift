//
//  TabBarControllerCordinator.swift
//  Course App
//
//  Created by Peter Surovy on 02.06.2024.
//

import UIKit

protocol TabBarControllerCoordinator: ViewControllerCoordinator {
    var tabBarController: UITabBarController { get }
}

extension TabBarControllerCoordinator {
    var rootViewController: UIViewController {
        tabBarController
    }
}
