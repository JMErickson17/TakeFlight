//
//  DataService.swift
//  TakeFlight
//
//  Created by Justin Erickson on 10/1/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import Foundation
import Alamofire

final class FlightDataService {
    
    static let instance = FlightDataService()
    private init() {}
    
    // MARK: Airports
    
/*
     This class is temporarily being used for airport data in AirportPickerVC and should be replaced with airports from the Firestore once operational
 */
    
    public private(set) var airports = [Airport]()
    
    func populateAirportData() {
        FirestoreDataService.instance.getAirports { (airports) in
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
}
