//
//  AppCoordinator.swift
//  Course App
//
//  Created by Peter Surovy on 01.06.2024.
//


import Combine
import UIKit

protocol AppCoordinating: ViewControllerCoordinator {}

final class AppCoordinator: AppCoordinating, ObservableObject {
    // MARK: Private properties
    private(set) lazy var rootViewController: UIViewController = {
        if isAuthorizedFlow {
            makeTabBarFlow().rootViewController
        } else {
            makeSignInFlow().rootViewController
        }
    }()
    private lazy var cancellables = Set<AnyCancellable>()
    // MARK: Public properties
    var childCoordinators = [Coordinator]()
    @Published var isAuthorizedFlow = true

    // MARK: Lifecycle
    init() {}
}

// MARK: - Start coordinator
extension AppCoordinator {
    func start() {
        setupAppUI()
    }
}

// MARK: - Setup UI
private extension AppCoordinator {
    func setupAppUI() {
        UITabBar.appearance().backgroundColor = .brown
        UITabBar.appearance().tintColor = .white
        UITabBarItem.appearance().setTitleTextAttributes(
            [
                NSAttributedString.Key.font: TextType.caption.uiFont
            ],
            for: .normal
        )
        UINavigationBar.appearance().tintColor = .white
    }
}

// MARK: - Factory methods
private extension AppCoordinator {
    func makeTabBarFlow() -> ViewControllerCoordinator {
        let mainTabCoordinator = MainTabBarCoordinator()
        startChildCoordinator(mainTabCoordinator)
        mainTabCoordinator.eventPublisher.sink { [weak self] event in
            self?.handle(event)
        }
        .store(in: &cancellables)
        return mainTabCoordinator
    }

    func makeSignInFlow() -> ViewControllerCoordinator {
        let signInCoordinator = SignInNavigationCoordinator()
        startChildCoordinator(signInCoordinator)
        signInCoordinator.eventPublisher.sink { [weak self] event in
            self?.handle(event)
        }
        .store(in: &cancellables)
        return signInCoordinator
    }
}

// MARK: - Event handling
private extension AppCoordinator {
    func handle(_ event: MainTabBarCoordinatorEvent) {
        switch event {
        case let .logout(coordinator):
            rootViewController = makeSignInFlow().rootViewController
            release(coordinator)
            isAuthorizedFlow = false
        }
    }

    func handle(_ event: SignInNavigationCoordinatorEvent) {
        switch event {
        case let .signedIn(coordinator):
            rootViewController = makeTabBarFlow().rootViewController
            release(coordinator)
            isAuthorizedFlow = true
        }
    }
}
