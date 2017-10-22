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
     Retrieves airport data for a given search query and passes an array of Airports to the completion handler.
     
     - Parameter query: The keyword used to filter the search criteria.
 */
    func getAirportDetails(forSearchQuery query: String, completion: @escaping (_ airport: Airport) -> Void) {
        // TODO: Get airport details
    }
}
