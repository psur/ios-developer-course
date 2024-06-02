//
//  HomeNavigationCoordinator.swift
//  Course App
//
//  Created by Peter Surovy on 02.06.2024.
//


import Combine
import os
import SwiftUI
import UIKit

protocol HomeNavigationCoordinating: NavigationControllerCoordinator, SwipingViewFactory {}

final class HomeNavigationCoordinator: HomeNavigationCoordinating {
    // MARK: Properties
    private(set) lazy var navigationController: UINavigationController = CustomNavigationController()
    private lazy var cancellables = Set<AnyCancellable>()
    private let eventSubject = PassthroughSubject<HomeNavigationCoordinatorEvent, Never>()
    private let logger = Logger()
    var childCoordinators: [any Coordinator] = []

    deinit {
        logger.info("Deinit HomeNavigationCoordinator")
    }
}

// MARK: - EventEmitting
extension HomeNavigationCoordinator: EventEmitting {
    var eventPublisher: AnyPublisher<HomeNavigationCoordinatorEvent, Never> {
        eventSubject.eraseToAnyPublisher()
    }
}

// MARK: - Start coordinator
extension HomeNavigationCoordinator {
    func start() {
        navigationController.setViewControllers(
            [makeHomeView()],
            animated: false
        )
    }
}

// MARK: - Factory methods
private extension HomeNavigationCoordinator {
    func makeHomeView() -> UIViewController {
        let homeView = HomeViewController()
        homeView.eventPublisher.sink { [weak self] event in
            self?.handle(event)
        }
        .store(in: &cancellables)
        return homeView
    }
}

// MARK: - Handling events
private extension HomeNavigationCoordinator {
    func handle(_ event: HomeViewEvent) {
        switch event {
        case let .itemTapped(joke):
            logger.info("Joke on home screen was tapped \(joke.text)")
            navigationController.pushViewController(makeSwipingView(), animated: true)
        }
    }
}
