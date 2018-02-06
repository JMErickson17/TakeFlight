//
//  FlightSegment.swift
//  TakeFlight
//
//  Created by Justin Erickson on 11/29/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import Foundation

struct Passengers: Codable {
    let adultCount: Int?
    let childCount: Int?
    let infantCount: Int?
}

struct Pricing: Codable {
    let baseFareTotal: Double
    let saleFareTotal: Double
    let saleTaxTotal: Double
    let saleTotal: Double
    let passengers: Passengers
}

struct FlightSegment: Codable {
    
    struct Leg: Codable {
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
    let carrier: Carrier
    let cabin: String
    let bookingCode: String
    let bookingCodeCount: Int
    let marriedSegmentGroup: String
    let subjectToGovernmentApproval: Bool?
    let duration: Int
    let connectionDuration: Int?
    let legs: [Leg]
    let pricing: [Pricing]
    
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
