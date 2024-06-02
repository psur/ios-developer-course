//
//  OnboardingView.swift
//  Course App
//
//  Created by Peter Surovy on 02.06.2024.
//


import Combine
import os
import SwiftUI

struct OnboardingView: View {
    // MARK: Private properties
    private let logger = Logger()
    private let eventSubject = PassthroughSubject<OnboardingViewEvent, Never>()
    private let page: OnboardingPage

    init(page: OnboardingPage) {
        self.page = page
    }

    var body: some View {
        VStack {
            Text("Hello, on page \(page.title)")

            Button("Next") {
                eventSubject.send(.nextPage(from: page))
                logger.info("Onboarding button on page tapped \(page.rawValue)")
            }

            Button("Close") {
                eventSubject.send(.close)
                logger.info("Onboarding button close tapped")
            }
        }
        .navigationTitle("Onboarding")
    }
}

// MARK: - EventEmitting
extension OnboardingView: EventEmitting {
    var eventPublisher: AnyPublisher<OnboardingViewEvent, Never> {
        eventSubject.eraseToAnyPublisher()
    }
}

#Preview {
    OnboardingView(page: OnboardingPage.welcome)
}
