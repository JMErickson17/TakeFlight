//
//  Destination.swift
//  TakeFlight
//
//  Created by Justin Erickson on 1/30/18.
//  Copyright © 2018 Justin Erickson. All rights reserved.
//

import Foundation

struct Destination: Codable {
    let city: String
    let state: String
    let country: String
    let imageURL: URL
    let airports: [String]
    
    init(city: String, state: String, country: String, imageURL: URL, airports: [String]) {
        self.city = city
        self.state = state
        self.country = country
        self.imageURL = imageURL
        self.airports = airports
    }
}
