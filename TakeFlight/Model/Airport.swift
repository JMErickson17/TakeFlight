//
//  Airport.swift
//  TakeFlight
//
//  Created by Justin Erickson on 10/15/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import Foundation

struct Airport: Codable {
    
    // MARK: Properties
    
    let name: String
    let city: String
    let state: String
    let stateAbbreviation: String
    let country: String
    let municipality: String
    let iata: String
    var coordinates: Coordinates
    
    var searchRepresentation: String {
        return "\(name) [\(iata.uppercased())]"
    }
    
    var locationString: String {
        if country == "US" {
            return cityAndState
        }
        return municipalityAndCountry
    }
    
    var cityAndCountry: String {
        return "\(city), \(country)"
    }
    
    var municipalityAndCountry: String {
        return "\(municipality), \(country)"
    }
    
    var cityAndState: String {
        return "\(city), \(state)"
    }
    
    var identifier: String {
        return iata
    }
    
    // MARK: Lifecycle
    
    init(name: String, city: String, state: String, stateAbbreviation: String,
         country: String, municipality: String, iata: String, lat: Double, lon: Double) {
        self.name = name
        self.city = city
        self.state = state
        self.stateAbbreviation = stateAbbreviation
        self.country = country
        self.municipality = municipality
        self.iata = iata
        self.coordinates = Coordinates(latitude: lat, longitude: lon)
    }
}

extension Airport: Equatable {
    static func ==(lhs: Airport, rhs: Airport) -> Bool {
        return lhs.name == rhs.name &&
                lhs.city == rhs.city &&
                lhs.state == rhs.state &&
                lhs.stateAbbreviation == rhs.stateAbbreviation &&
                lhs.country == rhs.country &&
                lhs.municipality == rhs.municipality &&
                lhs.iata == rhs.iata &&
                lhs.coordinates.latitude == rhs.coordinates.latitude &&
                lhs.coordinates.longitude == rhs.coordinates.longitude
        
    }
}
