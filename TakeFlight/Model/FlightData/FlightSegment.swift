//
//  FlightSegment.swift
//  TakeFlight
//
//  Created by Justin Erickson on 11/29/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import Foundation

struct FlightSegment {
    
    struct Leg {
        let id: String
        let aircraft: String
        let departureTime: DateAndTimeZone
        let arrivalTime: DateAndTimeZone
        let origin: String
        let originTerminal: String?
        let destination: String
        let destinationTerminal: String?
        let duration: Int
        let onTimePerformance: Int?
        let mileage: Int
        let meal: String?
        let secure: Bool?
        let connectionDuration: Int?
    }
    
    let id: String
    let flightNumber: String
    let carrier: (name: String, code: String)
    let cabin: String
    let bookingCode: String
    let bookingCodeCount: Int
    let marriedSegmentGroup: String
    let subjectToGovernmentApproval: Bool?
    let duration: Int
    let connectionDuration: Int?
    let legs: [Leg]
    
    var originAirportCode: String {
        return (legs.first?.origin) ?? ""
    }
    
    var destinationAirportCode: String {
        return (legs.last?.destination) ?? ""
    }

    var stopCount: Int {
        return legs.count - 1
    }
    
    var departureTime: DateAndTimeZone {
        return legs.first?.departureTime ?? DateAndTimeZone(date: Date.distantPast, timeZone: 0)
    }
    
    var arrivalTime: DateAndTimeZone {
        return legs.last?.arrivalTime ?? DateAndTimeZone(date: Date.distantPast, timeZone: 0)
    }
    
    var mileage: Int {
        return legs.reduce(0, { $0 + $1.mileage})
    }
}

// MARK: - Flight Segment: CustomStringConvertable

extension FlightSegment: CustomStringConvertible {
    
    var description: String {
        return """
                    ID: \(id)
                    Flight Number: \(flightNumber)
                    Carrier Name: \(carrier.name)
                    Carrier Code: \(carrier.code)
                    Cabin: \(cabin)
                    Booking Code: \(bookingCode)
                    Booking Code Count: \(bookingCodeCount)
                    Married Segment Group: \(marriedSegmentGroup)
                    Subject To Government Approval: \(String(describing: subjectToGovernmentApproval))
                    Legs: \(legs)\n
               """
    }
}

extension FlightSegment.Leg: CustomStringConvertible {
    
    var description: String {
        return """
                        ID: \(id)
                        Aircraft: \(aircraft)
                        Departure Time: \(departureTime)
                        Arrival Time: \(arrivalTime)
                        Origin: \(origin)
                        Origin Terminal: \(String(describing: originTerminal))
                        Destination: \(destination)
                        Destination Terminal: \(String(describing: destinationTerminal))
                        Duration: \(duration)
                        On Time Performance: \(String(describing: onTimePerformance))
                        Milage: \(mileage)
                        Meal: \(String(describing: meal))
                        Secure: \(String(describing: secure))
                        Connection Duration: \(String(describing: connectionDuration))
               """
    }
}
