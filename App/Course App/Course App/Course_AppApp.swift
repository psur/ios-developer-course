//
//  Course_AppApp.swift
//  Course App
//
//  Created by Peter Surovy on 27.04.2024.
//
import os
import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        FirebaseApp.configure()
        return true
    }
}



@main
struct Course_AppApp: App {
    // register app delegate for Firebase setup
        @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
        private let logger = Logger()
        private let isUIKit = true
        var body: some Scene {
            WindowGroup {
                homeView
                    .onAppear {
                        logger.info("Content view has appeared")
                    }
            }
        }
    
    @ViewBuilder
        var homeView: some View {

            if isUIKit {
                  HomeView()
            } else {
                // HomeViewSwiftUI()
            }
        }
}
