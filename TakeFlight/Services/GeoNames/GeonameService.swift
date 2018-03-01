//
//  GeonameService.swift
//  TakeFlight
//
//  Created by Justin Erickson on 2/28/18.
//  Copyright © 2018 Justin Erickson. All rights reserved.
//

import Foundation

struct GeonameService {
    
    private struct City: Codable {
        let country: String
        let geonameId: Int
        let name: String
        let subCountry: String?
        
        enum CodingKeys: String, CodingKey {
            case country
            case geonameId = "geonameid"
            case name
            case subCountry = "subcountry"
        }
    }
    
    static func geoname(forCity city: String) -> String? {
        guard let url = Bundle.main.url(forResource: "world-cities", withExtension: "json") else { fatalError("Could not find world-cities.json file") }
        do {
            let data = try Data(contentsOf: url)
            let cities = try JSONDecoder().decode([City].self, from: data)
            if let index = cities.index(where: { $0.name == city }) {
                return String(cities[index].geonameId)
            }
        } catch {
            print(error)
        }
        return nil
    }
}
