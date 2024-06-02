//
//  CancellablesContaining.swift
//  Course App
//
//  Created by Peter Surovy on 02.06.2024.
//

import Combine

/// Protocol used to enable `cancellables` to be used in default implementation of methods in protocols Coordinating
protocol CancellablesContaining: AnyObject {
    var cancellables: Set<AnyCancellable> { get set }
}
