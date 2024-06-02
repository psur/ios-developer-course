//
//  SwipingViewFactory.swift
//  Course App
//
//  Created by Peter Surovy on 02.06.2024.
//

import SwiftUI
import UIKit

protocol SwipingViewFactory {
    func makeSwipingView() -> UIViewController
}

extension SwipingViewFactory {
    func makeSwipingView() -> UIViewController {
        UIHostingController(rootView: SwipingView())
    }
}
