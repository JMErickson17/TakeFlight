//
//  Airport.swift
//  TakeFlight
//
//  Created by Justin Erickson on 10/15/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import Foundation

struct Airport: Decodable {
    
    // MARK: Properties
    
    public private(set) var name: String
    public private(set) var city: String
    public private(set) var state: String
    public private(set) var stateAbbreviation: String
    public private(set) var country: String
    public private(set) var iata: String
    public private(set) var icao: String
    public private(set) var lat: Double
    public private(set) var lon: Double
    public private(set) var timeZone: String
    
    // MARK: Lifetime
    
    init(name: String, city: String, state: String, stateAbbreviation: String, country: String, iata: String, icao: String, lat: Double, lon: Double, timeZone: String) {
        self.name = name
        self.city = city
        self.state = state
        self.stateAbbreviation = stateAbbreviation
        self.country = country
        self.iata = iata
        self.icao = icao
        self.lat = lat
        self.lon = lon
        self.timeZone = timeZone
    }
}

// MARK: - Decodable

extension Airport {
    
    enum CodingKeys: String, CodingKey {
        case name
        case city
        case state
        case stateAbbreviation
        case country
        case iata
        case icao
        case lat
        case lon
        case timeZone
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let name = try container.decode(String.self, forKey: .name)
        let city = try container.decode(String.self, forKey: .city)
        let state = try container.decode(String.self, forKey: .state)
        let stateAbbreviation = try container.decode(String.self, forKey: .stateAbbreviation)
        let country = try container.decode(String.self, forKey: .country)
        let iata = try container.decode(String.self, forKey: .iata)
        let icao = try container.decode(String.self, forKey: .icao)
        let lat = try container.decode(Double.self, forKey: .lat)
        let lon = try container.decode(Double.self, forKey: .lon)
        let timeZone = try container.decode(String.self, forKey: .timeZone)
        
        self.init(name: name, city: city, state: state, stateAbbreviation: stateAbbreviation, country: country, iata: iata, icao: icao, lat: lat, lon: lon, timeZone: timeZone)
    }
}

