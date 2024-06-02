//
//  OnboardingCoordinatorPresenting.swift
//  Course App
//
//  Created by Peter Surovy on 02.06.2024.
//

import Combine
import UIKit

protocol OnboardingCoordinatorPresenting {
    func handle(_ event: OnboardingNavigationCoordinatorEvent)
}

extension OnboardingCoordinatorPresenting where Self: Coordinator, Self: CancellablesContaining, Self: UINavigationControllerDelegate {
    func makeOnboardingFlow(initialPage: OnboardingPage? = nil, navigationController: UINavigationController? = nil) -> ViewControllerCoordinator {
        let coordinator = OnboardingNavigationCoordinator(
            initialPage: initialPage ?? OnboardingPage.welcome,
            navigationController: navigationController
        )
        // if navigation controller is injected we need to manage pop events
        if navigationController != nil {
            coordinator.navigationController.delegate = self
        }

        startChildCoordinator(coordinator)
        coordinator.eventPublisher
            .sink { [weak self] event in
                self?.handle(event)
            }
            .store(in: &cancellables)
        return coordinator
    }

    func handle(_ event: OnboardingNavigationCoordinatorEvent) {
        switch event {
        case let .dismiss(coordinator):
            release(coordinator)
        }
    }
}
