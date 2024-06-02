//
//  DeeplinkHandling.swift
//  Course App
//
//  Created by Peter Surovy on 01.06.2024.
//

import Foundation

protocol DeeplinkHandling: AnyObject {
    func handleDeeplink(_ deeplink: Deeplink)
}
