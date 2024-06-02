//
//  OnboardingViewEvent.swift
//  Course App
//
//  Created by Peter Surovy on 02.06.2024.
//

import Foundation

enum OnboardingViewEvent {
    case nextPage(from: OnboardingPage)
    case close
}