//
//  EventEmitting.swift
//  Course App
//
//  Created by Peter Surovy on 02.06.2024.
//

import Combine

protocol EventEmitting {
    associatedtype Event

    var eventPublisher: AnyPublisher<Event, Never> { get }
}
