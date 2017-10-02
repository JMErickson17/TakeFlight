//
//  Serializable.swift
//  TakeFlight
//
//  Created by Justin Erickson on 10/1/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import Foundation

protocol Serializable {
    func serialize() -> Data?
    func serializeToDictionary() -> [String: Any]?
}
