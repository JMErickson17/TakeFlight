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
 */
struct QPXExpress: Codable {
    
    // MARK: Types
    
    // TODO: Add CodingKeys enums
    struct Request: Codable {
        struct Passengers: Codable {
            let passengersKind = "qpxexpress#passengerCounts"
            let adultCount: Int!
            let childCount: Int?
        }
        
        struct Slice: Codable {
            let sliceKind = "qpxexpress#sliceInput"
            let origin: String!
            let destination: String!
            let date: Date!
            let maxStops: Int?
            let preferredCabin: String?
            let permittedDepartureTime: PermittedDepartureTime?
            
            struct PermittedDepartureTime: Codable {
                let permittedDepartureTimeKind = "qpxexpress#timeOfDayRange"
                let earliestTime: String?
                let latestTime: String?
            }
        }
        
        let passengers: Passengers
        let slice: [Slice]
        let maxPrice: String?
        let refundable: Bool?
    }
    
    // MARK: Properties
    
    var request: Request
    
    // MARK: Lifetime
    
/**
     Initializes a request object. All optional paramaters are optional and can be omitted.
     
     - Parameter adultCount: The number of adults on a flight ticket.
     - Parameter origin: Departing destination airport code
     - Parameter destination: Arrival destination airport code
     - Parameter date: Departure date.
 */
    init(adultCount: Int, origin: String, destination: String, date: Date,
         childCount: Int? = nil, maxStops: Int? = nil, preferredCabin: String? = nil,
         earliestTime: String? = nil, latestTime: String? = nil, maxPrice: String? = nil, refundable: Bool? = nil) {
        
        let passengers = Request.Passengers(adultCount: adultCount, childCount: childCount)
        let permittedDepartureTime = Request.Slice.PermittedDepartureTime(earliestTime: earliestTime, latestTime: latestTime)
        let slice = Request.Slice(origin: origin, destination: destination, date: date, maxStops: maxStops, preferredCabin: preferredCabin, permittedDepartureTime: permittedDepartureTime)
        
        self.request = Request(passengers: passengers, slice: [slice], maxPrice: maxPrice, refundable: refundable)
    }
}
