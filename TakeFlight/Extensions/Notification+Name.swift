//
//  Notification+Name.swift
//  TakeFlight
//
//  Created by Justin Erickson on 12/20/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let authStatusDidChange = Notification.Name(rawValue: "authStatusDidChange")
    static let userPropertiesDidChange = Notification.Name("userPropertiesDidChange")
}
