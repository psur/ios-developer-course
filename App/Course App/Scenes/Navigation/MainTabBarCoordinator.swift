//
//  MainTabBarCoordinator.swift
//  Course App
//
//  Created by Peter Surovy on 02.06.2024.
//


import Combine
import os
import SwiftUI
import UIKit

final class MainTabBarCoordinator: NSObject, TabBarControllerCoordinator, OnboardingCoordinatorPresenting, CancellablesContaining {
    // MARK: Private properties
    private let eventSubject = PassthroughSubject<MainTabBarCoordinatorEvent, Never>()
    private(set) lazy var tabBarController = makeTabBarController()
    private let logger = Logger()
    // MARK: Public properties
    var cancellables = Set<AnyCancellable>()
    var childCoordinators = [Coordinator]()

    // MARK: Lifecycle
    deinit {
        logger.info("Deinit MainTabBarCoordinator")
    }
}

// MARK: - Start coordinator
extension MainTabBarCoordinator {
    func start() {
        tabBarController.viewControllers = [
            makeHomeFlow().rootViewController,
            makeSwipingFlow().rootViewController,
            makeProfileFlow().rootViewController,
        ]
    }
}

// MARK: - EventEmitting
extension MainTabBarCoordinator: EventEmitting {
    var eventPublisher: AnyPublisher<MainTabBarCoordinatorEvent, Never> {
        eventSubject.eraseToAnyPublisher()
    }
}

// MARK: - Handle deeplinks
extension MainTabBarCoordinator {
    func handleDeeplink(_ deeplink: Deeplink) {
        switch deeplink {
        case let .onboarding(page):
            let coordinator = makeOnboardingFlow(initialPage: OnboardingPage(rawValue: page))
            tabBarController.present(coordinator.rootViewController, animated: true)
        default:
            break
        }

        childCoordinators.forEach { $0.handleDeeplink(deeplink) }
    }
}

// MARK: - Factory methods
private extension MainTabBarCoordinator {
    func makeTabBarController() -> UITabBarController {
        let tabBarController = UITabBarController()
        tabBarController.delegate = self
        return tabBarController
    }

    func makeHomeFlow() -> ViewControllerCoordinator {
        let homeCoordinator = HomeNavigationCoordinator()
        startChildCoordinator(homeCoordinator)
        homeCoordinator.rootViewController.tabBarItem = UITabBarItem(
            title: "Categories",
            image: UIImage(systemName: "list.dash.header.rectangle"),
            tag: 0
        )
        return homeCoordinator
    }

    func makeSwipingFlow() -> ViewControllerCoordinator {
        let swipingCoordinator = SwipingViewNavigationCoordinator()
        startChildCoordinator(swipingCoordinator)
        swipingCoordinator.rootViewController.tabBarItem = UITabBarItem(title: "Random", image: UIImage(systemName: "switch.2"), tag: 1)
        return swipingCoordinator
    }

    // TODO: enum for tab bar items
    func makeProfileFlow() -> ViewControllerCoordinator {
        let profileCoordinator = ProfileNavigationCoordinator()
        startChildCoordinator(profileCoordinator)
        profileCoordinator.eventPublisher
            .sink { [weak self] event in
                self?.handle(event)
            }
            .store(in: &cancellables)
        profileCoordinator.rootViewController.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.circle"), tag: 2)
        return profileCoordinator
    }
}

// MARK: - Handling events
private extension MainTabBarCoordinator {
    func handle(_ event: ProfileNavigationCoordinatorEvent) {
        switch event {
        case .logout:
            eventSubject.send(.logout(self))
        }
    }
}

// MARK: - UITabBarControllerDelegate
extension MainTabBarCoordinator: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        logger.info("MainTabBarDelegate on coordinator, tapped tab with controller \(viewController)")
    }
}

// MARK: - UINavigationControllerDelegate
extension MainTabBarCoordinator: UINavigationControllerDelegate {}
