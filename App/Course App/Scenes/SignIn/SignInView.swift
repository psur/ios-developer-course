//
//  SignInView.swift
//  Course App
//
//  Created by Peter Surovy on 02.06.2024.
//


import Combine
import SwiftUI

struct SignInView: View {
    @State private var email: String
    @State private var password: String

    private let eventSubject = PassthroughSubject<SignInViewEvent, Never>()

    init(email: String = "", password: String = "") {
        self.email = email
        self.password = password
    }

    var body: some View {
        Form {
            TextField("Email", text: $email)
            TextField("Password", text: $password)
                .textContentType(.password)
            Button("Sign in") {
                eventSubject.send(.signedIn)
            }
        }
    }
}

// MARK: - EventEmitting
extension SignInView: EventEmitting {
    var eventPublisher: AnyPublisher<SignInViewEvent, Never> {
        eventSubject.eraseToAnyPublisher()
    }
}

#Preview {
    SignInView(email: "email@email.com", password: "password")
}
