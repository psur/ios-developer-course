//
//  ViewControllerCoordinator.swift
//  Course App
//
//  Created by Peter Surovy on 02.06.2024.
//

import UIKit

protocol ViewControllerCoordinator: Coordinator {
    var rootViewController: UIViewController { get }
}
