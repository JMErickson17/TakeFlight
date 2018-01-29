//
//  FlightSegment+CustomStringConvertable.swift
//  TakeFlight
//
//  Created by Justin Erickson on 1/29/18.
//  Copyright © 2018 Justin Erickson. All rights reserved.
//

import Foundation

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
