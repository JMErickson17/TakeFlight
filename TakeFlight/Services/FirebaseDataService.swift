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
     Retrieves airport data from Firebase Database and passes an array of airports to the completion handler
 */
    func getAirports(completion: @escaping ([Airport]) -> Void) {
        var airports = [Airport]()
        
        DispatchQueue.global().sync {
            REF_AIRPORTS.observeSingleEvent(of: .value, with: { (snapshot) in
                if let snapshot = snapshot.value as? [[String: Any]] {
                    for snap in snapshot {
                        if let airport = Airport(airportDictionary: snap) {
                            airports.append(airport)
                        }
                    }
                }
                completion(airports)
            })
        }
    }
}
