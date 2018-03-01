//
//  DestinationDetails.swift
//  TakeFlight
//
//  Created by Justin Erickson on 2/28/18.
//  Copyright © 2018 Justin Erickson. All rights reserved.
//

import Foundation

struct DestinationDetails {
    let name: String
    let geonameId: String
    let timezone: String
    let scores: [Score]
    let boundingBox: BoundingBox
    let weather: Weather
    let coordinates: Coordinates
    let population: Int
}
