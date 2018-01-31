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
    let imageURL: String
    let airports: [String]
    
    init(city: String, state: String, country: String, imageURL: String, airports: [String]) {
        self.city = city
        self.state = state
        self.country = country
        self.imageURL = imageURL
        self.airports = airports
    }
    
    init(city: String, state: String, country: String) {
        self.init(city: city, state: state, country: country, imageURL: "" , airports: [])
    }
    
    init(city: String, state: String, country: String, airports: [String]) {
        self.init(city: city, state: state, country: country, imageURL: "", airports: airports)
    }
}
