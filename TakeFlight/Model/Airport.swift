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
    
    public private(set) var name: String
    public private(set) var city: String
    public private(set) var state: String
    public private(set) var stateAbbreviation: String
    public private(set) var country: String
    public private(set) var iata: String
    public private(set) var lat: Double
    public private(set) var lon: Double
    public private(set) var timeZone: String
    
    public var searchRepresentation: String {
        return "\(name) [\(iata.uppercased())]"
    }
    
    public var cityAndCountry: String {
        return "\(city), \(country)"
    }
    
    public var cityAndState: String {
        return "\(city), \(state)"
    }
    
    public var identifier: String {
        return iata
    }
    
    // MARK: Lifetime
    
    init(name: String, city: String, state: String, stateAbbreviation: String, country: String, iata: String, lat: Double, lon: Double, timeZone: String) {
        self.name = name
        self.city = city
        self.state = state
        self.stateAbbreviation = stateAbbreviation
        self.country = country
        self.iata = iata
        self.lat = lat
        self.lon = lon
        self.timeZone = timeZone
    }
    
    init?(airportDictionary: [String: Any]) {
        guard let name = airportDictionary["name"] as? String else { return nil }
        guard let city = airportDictionary["city"] as? String else { return nil }
        guard let state = airportDictionary["state"] as? String else { return nil }
        guard let stateAbbreviation = airportDictionary["stateAbbreviation"] as? String else { return nil }
        guard let country = airportDictionary["country"] as? String else { return nil }
        guard let iata = airportDictionary["iata"] as? String else { return nil }
        guard let lat = airportDictionary["lat"] as? String else { return nil }
        guard let lon = airportDictionary["lon"] as? String else { return nil }
        guard let timeZone = airportDictionary["timeZone"] as? String else { return nil }
        
        self.init(name: name, city: city, state: state, stateAbbreviation: stateAbbreviation, country: country, iata: iata, lat: Double(lat)!, lon: Double(lon)!, timeZone: timeZone)
    }
    
}

