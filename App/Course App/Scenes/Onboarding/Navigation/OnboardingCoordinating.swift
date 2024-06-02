//
//  OnboardingCoordinating.swift
//  Course App
//
//  Created by Peter Surovy on 02.06.2024.
//

import Combine
import SwiftUI
import UIKit

protocol OnboardingCoordinating: NavigationControllerCoordinator {
    func handle(_ event: OnboardingViewEvent)
}

extension OnboardingCoordinating where Self: CancellablesContaining {
    func makeOnboardingView(page: OnboardingPage? = nil) -> UIViewController {
        let initialPage = page ?? OnboardingPage.welcome
        let onboardingView = OnboardingView(page: initialPage)
        onboardingView.eventPublisher.sink { [weak self] event in
            self?.handle(event)
        }
        .store(in: &cancellables)

        return UIHostingController(rootView: onboardingView)
    }

    func handle(_ event: OnboardingViewEvent) {
        switch event {
        case .close:
            if navigationController.presentingViewController != nil {
                // Dismissing is detected on CustomNavigationController and event publisher is subscribed to manage releasing resources properly
                navigationController.dismiss(animated: true)
            } else {
                navigationController.popToRootViewController(animated: true)
            }

        case let .nextPage(from):
            // never ending cycle
            var newPage: OnboardingPage
            if from == OnboardingPage.allCases.last {
                newPage = OnboardingPage.welcome
            } else {
                // swiftlint:disable:next force_unwrapping
                newPage = OnboardingPage(rawValue: from.rawValue + 1)!
            }

            navigationController.pushViewController(makeOnboardingView(page: newPage), animated: true)
        }
    }
}
