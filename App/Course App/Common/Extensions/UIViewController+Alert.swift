//
//  UIViewController+Alert.swift
//  Course App
//
//  Created by Peter Surovy on 02.06.2024.
//


import UIKit

extension UIViewController {
    func showInfoAlert(
        title: String,
        message: String? = nil,
        okHandler: VoidAction? = nil,
        cancelHandler: VoidAction? = nil
    ) {
        guard presentedViewController == nil else {
            return
        }

        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let okAction = UIAlertAction(
            title: "OK",
            style: .default
        ) { _ in
            okHandler?()
        }
        let cancelAction = UIAlertAction(
            title: "Cancel",
            style: .cancel
        ) { _ in
            cancelHandler?()
        }
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)

        present(alertController, animated: true)
    }
}
