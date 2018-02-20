//
//  Destination.swift
//  TakeFlight
//
//  Created by Justin Erickson on 1/30/18.
//  Copyright © 2018 Justin Erickson. All rights reserved.
//

import Foundation
import CoreLocation

struct Destination: Codable {
    let city: String
    let state: String
    let country: String
    let coordinates: Coordinates
    let population: Int
    let airports: [String]
    
    init(city: String, state: String, country: String, coordinates: Coordinates, population: Int, airports: [String]) {
        self.city = city
        self.state = state
        self.country = country
        self.coordinates = coordinates
        self.population = population
        self.airports = airports
    }
}
