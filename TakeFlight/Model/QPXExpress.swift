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
    
    struct Request: Codable {
        struct Passengers: Codable {
            let kind = "qpxexpress#passengerCounts"
            let adultCount: Int!
            let childCount: Int?
        }
        
        struct Slice: Codable {
            let kind = "qpxexpress#sliceInput"
            let origin: String!
            let destination: String!
            // TODO: Change date back to Date type
            let date: Date!
            let maxStops: Int?
            let preferredCabin: String?
            let permittedDepartureTime: PermittedDepartureTime?
            
            struct PermittedDepartureTime: Codable {
                let kind = "qpxexpress#timeOfDayRange"
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
     Initializes a request object. All optional paramaters can be omitted.
     
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

// MARK: - Dictionary Representation

extension QPXExpress {
    
    var dictionaryRepresentation: [String: Any] {
        var request = [String: Any]()
        var passengers = [String: Any]()
        var slice = [String: Any]()
        var permittedDepartureTime = [String: Any]()
        
        passengers["kind"] = self.request.passengers.kind
        passengers["adultCount"] = self.request.passengers.adultCount
        
        if let childCount = self.request.passengers.childCount {
            passengers["childCount"] = childCount
        }
        
        slice["kind"] = self.request.slice.first?.kind
        slice["origin"] = self.request.slice.first?.origin
        slice["destination"] = self.request.slice.first?.destination
        slice["date"] = self.request.slice.first?.date.toQPXExpressString()
        
        if let maxStops = self.request.slice.first?.maxStops {
            slice["maxStops"] = maxStops
        }
        
        if let preferredCabin = self.request.slice.first?.preferredCabin {
            slice["preferredCabin"] = preferredCabin
        }
        
        permittedDepartureTime["kind"] = self.request.slice.first?.permittedDepartureTime?.kind
        
        if let earliestTime = self.request.slice.first?.permittedDepartureTime?.earliestTime {
            permittedDepartureTime["earliestTime"] = earliestTime
        }
        
        if let latestTime = self.request.slice.first?.permittedDepartureTime?.latestTime {
            permittedDepartureTime["latestTime"] = latestTime
        }
        
        slice["permittedDepartureTime"] = permittedDepartureTime
        
        request["passengers"] = passengers
        request["slice"] = [slice]
        
        if let maxPrice = self.request.maxPrice {
            request["maxPrice"] = maxPrice
        }
        
        if let refundable = self.request.refundable {
            request["refundable"] = refundable
        }
        
        return ["request": request]
    }
}

