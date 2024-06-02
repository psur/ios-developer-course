//
//  ProfileNavigatorCoordinator.swift
//  Course App
//
//  Created by Peter Surovy on 02.06.2024.
//


import Combine
import os
import SwiftUI
import UIKit

protocol ProfileCoordinating: NavigationControllerCoordinator {}

final class ProfileNavigationCoordinator: NSObject, ProfileCoordinating, OnboardingCoordinatorPresenting, CancellablesContaining {
    // MARK: Private properties
    private(set) lazy var navigationController: UINavigationController = CustomNavigationController()
    private let eventSubject = PassthroughSubject<ProfileNavigationCoordinatorEvent, Never>()
    private let logger = Logger()
    // MARK: Public properties
    var cancellables = Set<AnyCancellable>()
    var childCoordinators: [any Coordinator] = []

    // MARK: Lifecycle
    deinit {
        logger.info("Deinit ProfileNavigationCoordinator")
    }
}

// MARK: - EventEmitting
extension ProfileNavigationCoordinator: EventEmitting {
    var eventPublisher: AnyPublisher<ProfileNavigationCoordinatorEvent, Never> {
        eventSubject.eraseToAnyPublisher()
    }
}

// MARK: - Start coordinator
extension ProfileNavigationCoordinator {
    func start() {
        navigationController.setViewControllers(
            [makeProfileView()],
            animated: false
        )
    }
}

// MARK: - Factory methods
private extension ProfileNavigationCoordinator {
    func makeProfileView() -> UIViewController {
        let profileView = ProfileView()
        profileView.eventPublisher.sink { [weak self] event in
            guard let self else {
                return
            }
            switch event {
            case .logout:
                eventSubject.send(.logout)

            case .onboarding:
                _ = makeOnboardingFlow(navigationController: self.navigationController)
            case .onboardingModal:
                self.navigationController.present(
                    makeOnboardingFlow().rootViewController,
                    animated: true
                )
            }
        }
        .store(in: &cancellables)

        return UIHostingController(rootView: profileView)
    }
}

// MARK: - UINavigationControllerDelegate
extension ProfileNavigationCoordinator: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if navigationController.viewControllers.count == 1 {
            if let onboardingCoordinator = childCoordinators.first(where: { $0 is OnboardingCoordinating }) {
                release(onboardingCoordinator)
            }
        }
    }
}
