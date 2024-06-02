//
//  ProfileView.swift
//  Course App
//
//  Created by Peter Surovy on 02.06.2024.
//


import Combine
import SwiftUI

struct ProfileView: View {
    private let eventSubject = PassthroughSubject<ProfileViewEvent, Never>()

    var body: some View {
        VStack {
            Button("Onboarding") {
                eventSubject.send(.onboarding)
            }

            Button("Onboarding modal") {
                eventSubject.send(.onboardingModal)
            }

            Button("Logout") {
                eventSubject.send(.logout)
            }
        }
        .navigationTitle("Profile")
    }
}

// MARK: - EventEmitting
extension ProfileView: EventEmitting {
    var eventPublisher: AnyPublisher<ProfileViewEvent, Never> {
        eventSubject.eraseToAnyPublisher()
    }
}

#Preview {
    ProfileView()
}
