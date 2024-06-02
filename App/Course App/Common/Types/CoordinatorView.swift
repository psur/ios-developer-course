//
//  CoordinatorView.swift
//  Course App
//
//  Created by Peter Surovy on 02.06.2024.
//

import os
import SwiftUI
import UIKit

// MARK: UIViewControllerRepresentable
struct CoordinatorView<T: ViewControllerCoordinator>: UIViewControllerRepresentable {
    let coordinator: T
    private let logger = Logger()

    func makeUIViewController(context: Context) -> UIViewController {
        logger.info("Make UIViewController \(coordinator.rootViewController)")
        return coordinator.rootViewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
//        logger.info("updateUIViewController \(context.environment)")
    }
}
