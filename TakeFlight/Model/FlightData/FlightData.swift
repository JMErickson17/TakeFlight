//
//  FlightData.swift
//  TakeFlight
//
//  Created by Justin Erickson on 10/1/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import UIKit

struct FlightData {
    
    private(set) var departingFlight: Flight
    private(set) var returningFlight: Flight?
    
    let createdTimeStamp: Date
    let saleTotal: Double
    let baseFareTotal: Double
    let saleFareTotal: Double
    let saleTaxTotal: Double
    let fareCalculation: String
    let latestTicketingTime: DateAndTimeZone
    let refundable: Bool?
    let taxCountry: String
    
    init(createdTimeStamp: Date, baseFareTotal: Double, saleFareTotal: Double, saleTaxTotal: Double,
         saleTotal: Double, fareCalculation: String, latestTicketingTime: DateAndTimeZone, refundable: Bool,
         taxCountry: String, departingFlightSegments: [FlightSegment], returningFlightSegments: [FlightSegment]? = nil) {
        self.createdTimeStamp = createdTimeStamp
        self.saleTotal = saleTotal
        self.baseFareTotal = baseFareTotal
        self.saleFareTotal = saleFareTotal
        self.saleTaxTotal = saleTaxTotal
        self.fareCalculation = fareCalculation
        self.latestTicketingTime = latestTicketingTime
        self.refundable = refundable
        self.taxCountry = taxCountry
        
        self.departingFlight = Flight(segments: departingFlightSegments)
        
        if let returningFlightSegments = returningFlightSegments {
            self.returningFlight = Flight(segments: returningFlightSegments)
        }
    }
    
    var longDescription: String {
        return "Orlando Florida to Los Angeles California"
    }
    
    var shortDescription: String {
        return "\(departingFlight.originAirportCode)-\(departingFlight.destinationAirportCode)"
    }
    
    var isRoundTrip: Bool {
        return returningFlight != nil
    }
}

extension FlightData: CustomStringConvertible {
    
    var description: String {
        return """
                ----------------------- Flight Data -----------------------
                    Date Created: \(createdTimeStamp)
                    Sale Total: \(saleTotal)
                    Base Fare Total: \(baseFareTotal)
                    Sale Fare Total: \(saleFareTotal)
                    Sale Tax Total: \(saleTaxTotal)
                    Fare Calculation: \(fareCalculation)
                    Latest Ticketing Time: \(latestTicketingTime)
                    Refundable: \(String(describing: refundable))
                    Tax Country: \(taxCountry)\n
                    -------------------- Departing Flight --------------------
                        \(departingFlight)\n
                    -------------------- Returning Flight --------------------
                        \(String(describing: returningFlight))\n
               """
    }
}


extension FlightData {
    struct Flight {
        
        let segments: [FlightSegment]
        
        var carrier: String {
            return (segments.first?.carrier.name) ?? ""
        }
        
        var departureTime: DateAndTimeZone {
            return segments.first?.departureTime ?? DateAndTimeZone(date: Date.distantPast, timeZone: 0)
        }
        
        var arrivalTime: DateAndTimeZone {
            return segments.last?.arrivalTime ?? DateAndTimeZone(date: Date.distantPast, timeZone: 0)
        }
        
        var stopCount: Int {
            return segments.reduce(0, { $0 + $1.stopCount }) + (segments.count - 1)
        }
        
        var duration: Int {
            return segments.reduce(0, { $0 + $1.duration })
        }
        
        var bookingCode: String {
            if segments.count == 1 {
                return segments[0].bookingCode
            } else {
                return "Multi Segment"
            }
        }
        
        var originAirportCode: String {
            return (segments.first?.originAirportCode) ?? ""
        }
        
        var destinationAirportCode: String {
            return (segments.last?.destinationAirportCode) ?? ""
        }
    }
}
