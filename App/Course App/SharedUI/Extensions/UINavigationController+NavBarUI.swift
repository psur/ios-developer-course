//
//  UINavigationController+NavBarUI.swift
//  Course App
//
//  Created by Peter Surovy on 02.06.2024.
//

import UIKit

extension UINavigationController {
    func setupNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .brown
        appearance.shadowImage = UIImage()
        appearance.shadowColor = .clear
        appearance.titleTextAttributes = [
            NSAttributedString.Key.font: TextType.navigationTitle.uiFont,
            NSAttributedString.Key.foregroundColor: TextType.navigationTitle.uiColor
        ]

        navigationBar.standardAppearance = appearance
        navigationBar.compactAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
    }
}
