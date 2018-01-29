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
    let coordinates: Coordinates
    
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
        self.coordinates = Coordinates(latitide: lat, longitude: lon)
    }
    
    init?(airportDictionary: [String: Any]) {
        guard let name = airportDictionary["name"] as? String else { return nil }
        guard let city = airportDictionary["city"] as? String else { return nil }
        guard let state = airportDictionary["state"] as? String else { return nil }
        guard let stateAbbreviation = airportDictionary["stateAbbreviation"] as? String else { return nil }
        guard let country = airportDictionary["country"] as? String else { return nil }
        guard let municipality = airportDictionary["municipality"] as? String else { return nil }
        guard let iata = airportDictionary["iata"] as? String else { return nil }
        guard let lat = airportDictionary["lat"] as? String else { return nil }
        guard let lon = airportDictionary["lon"] as? String else { return nil }
        
        self.init(name: name, city: city, state: state, stateAbbreviation: stateAbbreviation,
                  country: country, municipality: municipality, iata: iata, lat: Double(lat)!, lon: Double(lon)!)
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
                lhs.coordinates.latitide == rhs.coordinates.latitide &&
                lhs.coordinates.longitude == rhs.coordinates.longitude
        
    }
}
