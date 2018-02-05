//
//  UserSearchRequest.swift
//  TakeFlight
//
//  Created by Justin Erickson on 12/21/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import Foundation

struct FlightSearchRequest {
    var timeStamp: Date
    var origin: Airport?
    var destination: Airport?
    var departureDate: Date?
    var returnDate: Date?
    var numberOfAdultPassengers: Int
    var numberOfChildPassengers: Int
    var numberOfInfantPassengers: Int
    
    init() {
        self.timeStamp = Date()
        numberOfAdultPassengers = 1
        numberOfChildPassengers = 0
        numberOfInfantPassengers = 0
    }
    
    init(origin: Airport?, destination: Airport?, departureDate: Date?, returnDate: Date?, numberOfAdultPassengers: Int? = 1, numberOfChildPassengers: Int? = 0, numberOfInfantPassengers: Int? = 0) {
        self.timeStamp = Date()
        self.origin = origin
        self.destination = destination
        self.departureDate = departureDate
        self.returnDate = returnDate
        self.numberOfAdultPassengers = numberOfAdultPassengers!
        self.numberOfChildPassengers = numberOfChildPassengers!
        self.numberOfInfantPassengers = numberOfInfantPassengers!
    }
    
    var dictionaryRepresentation: [String: Any] {
        return [
            "timeStamp": timeStamp,
            "origin": origin?.identifier as Any,
            "destination": destination?.identifier as Any,
            "departureDate": departureDate as Any,
            "returnDate": returnDate as Any,
            "adultPassengers": numberOfAdultPassengers as Any,
            "childPassengers": numberOfChildPassengers as Any,
            "infantPassenger": numberOfInfantPassengers as Any
        ]
    }
    
    func isValid(for searchType: SearchType) -> Bool {
        guard origin != nil else { return false }
        guard destination != nil else { return false }
        guard departureDate != nil else { return false }
        if searchType == .roundTrip {
            guard returnDate != nil else { return false }
        }
        return true
    }
}
