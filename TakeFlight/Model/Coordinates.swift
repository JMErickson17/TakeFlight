//
//  Coordinates.swift
//  TakeFlight
//
//  Created by Justin Erickson on 1/28/18.
//  Copyright © 2018 Justin Erickson. All rights reserved.
//

import Foundation
import CoreLocation

struct Coordinates: Codable {
    var latitude: Double
    var longitude: Double
}

extension Coordinates {
    var clLocation: CLLocation {
        return CLLocation(latitude: latitude, longitude: longitude)
    }
}
