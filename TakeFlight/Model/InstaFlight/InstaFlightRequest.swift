//
//  InstaFlights.swift
//  TakeFlight
//
//  Created by Justin Erickson on 11/15/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import Foundation

class InstaFlightRequest {
    
    var origin: String
    var destination: String
    var departureDate: String?
    var returnDate: String?
    var pointOfSaleCountry: String
    var minFare: String?
    var maxFare: String?
    
    var onlineItinerariesOnly = "N"
    var limit = 10
    var sortBy = "totalfare"
    var order = "asc"
    
    init(origin: String, destination: String, pointOfSaleCountry: String) {
        self.origin = origin
        self.destination = destination
        self.pointOfSaleCountry = pointOfSaleCountry
    }
    
    func withDepartureDate(departureDate: String) -> InstaFlightRequest {
        self.departureDate = departureDate
        return self
    }
    
    func withReturnDate(returnDate: String) -> InstaFlightRequest {
        self.returnDate = returnDate
        return self
    }
    
}
