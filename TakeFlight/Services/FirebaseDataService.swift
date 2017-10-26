//
//  FirebaseDataService.swift
//  TakeFlight
//
//  Created by Justin Erickson on 10/15/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import Foundation
import Firebase

final class FirebaseDataService {
    
    static let instance = FirebaseDataService()
    private init() {}
    
    // MARK: Properties
    
    let REF_BASE = Constants.DB_BASE
    let REF_AIRPORTS = Constants.DB_BASE.child("airports")
    
    // MARK: Convenience
    
/**
     Returns airport data for all airports in the Database
 */
    func getAirports(completion: @escaping ([Airport]) -> Void) {
        var airports = [Airport]()
        REF_AIRPORTS.observeSingleEvent(of: .value) { (snapshot) in
            if let snapshot = snapshot.value as? [[String: Any]] {
                for snap in snapshot {
                    guard let name = snap["name"] as? String else { continue }
                    guard let city = snap["city"] as? String else { continue }
                    guard let state = snap["state"] as? String else { continue }
                    guard let stateAbbreviation = snap["stateAbbreviation"] as? String else { continue }
                    guard let country = snap["country"] as? String else { continue }
                    guard let iata = snap["iata"] as? String else { continue }
                    guard let lat = snap["lat"] as? String else { continue }
                    guard let lon = snap["lon"] as? String else { continue }
                    guard let timeZone = snap["timeZone"] as? String else { continue }
                    
                    let airport = Airport(name: name, city: city, state: state, stateAbbreviation: stateAbbreviation, country: country, iata: iata, lat: Double(lat)!, lon: Double(lon)!, timeZone: timeZone)
                    
                    airports.append(airport)
                }
                completion(airports)
            }
        }

    }
}
