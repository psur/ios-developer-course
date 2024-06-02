//
//  SwipingViewNavigationCoordinator.swift
//  Course App
//
//  Created by Peter Surovy on 02.06.2024.
//

import os
import SwiftUI
import UIKit

final class SwipingViewNavigationCoordinator: NSObject, NavigationControllerCoordinator, SwipingViewFactory {
    // MARK: Private properties
    private(set) lazy var navigationController: UINavigationController = CustomNavigationController()
    private let logger = Logger()
    // MARK: Public properties
    var childCoordinators = [Coordinator]()

    // MARK: Lifecycle
    deinit {
        logger.info("Deinit SwipingViewNavigationCoordinator")
    }
}
// MARK: - Start
extension SwipingViewNavigationCoordinator {
    func start() {
        navigationController.setViewControllers(
            [makeSwipingView()],
            animated: false
        )
    }
}
