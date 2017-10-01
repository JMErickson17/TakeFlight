//
//  QPXExpressBuilder.swift
//  TakeFlight
//
//  Created by Justin Erickson on 10/1/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import Foundation

/**
     The QPXExpressBuilder struct provides a convenient way to build QPXExpress requests.
 
     The minimum fields that must be supplied to the initializer are numberOfPassengers, origin, destination, and date.
 */
struct QPXExpressBuilder {
    
    // MARK: Properties
    
    public private(set) var adultCount: Int!
    public private(set) var origin: String!
    public private(set) var destination: String!
    public private(set) var date: Date!
    
    static let PASSENGERS_KIND = "qpxexpress#passengerCounts"
    static let SLICE_KIND = "qpxexpress#sliceInput"
    static let PERMITTED_DEPARTURE_TIME_KIND = "qpxexpress#timeOfDayRange"
    
    // MARK: Lifetime
    
/**
     Initializer with the minumim required values for the API, use a convenience initializer for more options.
 */
    init(adultCount: Int, origin: String, destination: String, date: Date) {
        self.adultCount = adultCount
        self.origin = origin
        self.destination = destination
        self.date = date
    }
}
