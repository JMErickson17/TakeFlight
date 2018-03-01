//
//  BoundingBox.swift
//  TakeFlight
//
//  Created by Justin Erickson on 2/28/18.
//  Copyright © 2018 Justin Erickson. All rights reserved.
//

import Foundation

struct BoundingBox: Codable {
    let north: Double
    let east: Double
    let south: Double
    let west: Double
}
