//
//  OnboardingNavigationCoordinator.swift
//  Course App
//
//  Created by Peter Surovy on 02.06.2024.
//

import Combine
import os
import SwiftUI
import UIKit

final class OnboardingNavigationCoordinator: OnboardingCoordinating, CancellablesContaining {
    // MARK: Private properties
    private(set) lazy var navigationController: UINavigationController = makeNavigationController()
    private let eventSubject = PassthroughSubject<OnboardingNavigationCoordinatorEvent, Never>()
    private let initialPage: OnboardingPage
    private let logger = Logger()
    private var isPushNavigation: Bool = false
    // MARK: Public properties
    var cancellables = Set<AnyCancellable>()
    var childCoordinators: [any Coordinator] = []

    // MARK: Lifecycle
    deinit {
        logger.info("Deinit OnboardingNavigationCoordinator")
    }

    init(initialPage: OnboardingPage = .welcome, navigationController: UINavigationController? = nil) {
        self.initialPage = initialPage
        if let navigationController {
            isPushNavigation = true
            self.navigationController = navigationController
        }
    }
}

// MARK: - EventEmitting
extension OnboardingNavigationCoordinator: EventEmitting {
    var eventPublisher: AnyPublisher<OnboardingNavigationCoordinatorEvent, Never> {
        eventSubject.eraseToAnyPublisher()
    }
}

// MARK: - Start coordinator
extension OnboardingNavigationCoordinator {
    func start() {
        if isPushNavigation {
            navigationController.pushViewController(makeOnboardingView(page: initialPage), animated: true)
        } else {
            navigationController.setViewControllers(
                [makeOnboardingView(page: initialPage)],
                animated: false
            )
        }
    }
}

// MARK: - Factory methods
private extension OnboardingNavigationCoordinator {
    func makeNavigationController() -> UINavigationController {
        let navigationController = CustomNavigationController()
        navigationController.eventPublisher.sink { [weak self] event in
            self?.handle(event)
        }
        .store(in: &cancellables)
        navigationController.modalTransitionStyle = .crossDissolve
        return navigationController
    }
}

// MARK: - Event handling
private extension OnboardingNavigationCoordinator {
    func handle(_ event: CustomNavigationControllerEvent) {
        switch event {
        case .dismiss:
            self.eventSubject.send(.dismiss(self))
        default:
            break
        }
    }
}
