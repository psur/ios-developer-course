//
//  Course_AppApp.swift
//  Course App
//
//  Created by Peter Surovy on 27.04.2024.
//

import FirebaseCore
import os
import SwiftUI

// App delegate
final class AppDelegate: NSObject, UIApplicationDelegate {
    // Delegate pattern
    weak var deeplinkHandler: DeeplinkHandling?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        FirebaseApp.configure()
        deeplinkFromService()
        return true
    }

    func deeplinkFromService() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            self?.deeplinkHandler?.handleDeeplink(.onboarding(page: 2))
        }
    }
}

@main
// swiftlint:disable:next type_name
struct Course_AppApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @ObservedObject private var appCoordinator = AppCoordinator()

    private let logger = Logger()

    init() {
        appCoordinator.start()
        delegate.deeplinkHandler = appCoordinator
    }

    var body: some Scene {
        WindowGroup {
            CoordinatorView(coordinator: appCoordinator)
                .id(appCoordinator.isAuthorizedFlow)
                .ignoresSafeArea(edges: .all)
                .onAppear {
                    logger.info("Content view has appeared")
                }
        }
    }
}
