//
//  OnboardingPage.swift
//  Course App
//
//  Created by Peter Surovy on 02.06.2024.
//

import Foundation

enum OnboardingPage: Int, CaseIterable {
    case welcome
    case services
    case letstart

    var title: String {
        switch self {
        case .letstart:
            "Lets start"
        case .services:
            "Services"
        case .welcome:
            "Welcome"
        }
    }
}
