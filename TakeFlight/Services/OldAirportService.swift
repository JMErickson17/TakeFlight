//
//  DataService.swift
//  TakeFlight
//
//  Created by Justin Erickson on 10/1/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import Foundation
import Firebase

final class OldAirportService {
    
    static let instance = OldAirportService()
    private init() {}
    
    // MARK: Airports
    
/*
     This class is temporarily being used for airport data in AirportPickerVC and should be replaced with airports from the Firestore once operational
 */
    
    public private(set) var airports = [Airport]()
    
    func populateAirportData() {
        getAirports { (airports) in
            self.airports = airports
        }
    }
    
    func searchAirports(forQuery query: String) -> [Airport] {
        return airports.filter { $0.searchRepresentation.lowercased().contains(query.lowercased()) }
    }
    
    func airport(forCode code: String) -> Airport? {
        if let index = airports.index(where: { $0.iata == code }) {
            return airports[index]
        }
        return nil
    }
    
    private static let REF_BASE = Database.database().reference()
    private let REF_AIRPORTS = REF_BASE.child("airports")
    
    func getAirports(completion: @escaping ([TakeFlight.Airport]) -> Void) {
        var airports = [TakeFlight.Airport]()
        
        DispatchQueue.global(qos: .default).async {
            self.REF_AIRPORTS.observeSingleEvent(of: .value, with: { (snapshot) in
                if let snapshot = snapshot.value as? [[String: Any]] {
                    for snap in snapshot {
                        if let airport = TakeFlight.Airport(airportDictionary: snap) {
                            airports.append(airport)
                        }
                    }
                }
                completion(airports)
            })
        }
    }
}
