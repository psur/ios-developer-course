//
//  NavigationControllerCoordinator.swift
//  Course App
//
//  Created by Peter Surovy on 02.06.2024.
//

import UIKit

protocol NavigationControllerCoordinator: ViewControllerCoordinator {
    var navigationController: UINavigationController { get }
}

extension NavigationControllerCoordinator {
    var rootViewController: UIViewController {
        navigationController
    }
}
