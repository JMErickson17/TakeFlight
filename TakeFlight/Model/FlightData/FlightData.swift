//
//  FlightData.swift
//  TakeFlight
//
//  Created by Justin Erickson on 10/1/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import UIKit
import Firebase

struct FlightData: Codable {
    
    private(set) var departingFlight: Flight
    private(set) var returningFlight: Flight?
    
    let uid: String
    let createdTimeStamp: Date
    let saleTotal: Double
    let baseFareTotal: Double
    let saleFareTotal: Double
    let saleTaxTotal: Double
    let fareCalculation: String
    let latestTicketingTime: DateAndTimeZone
    let refundable: Bool?
    let taxCountry: String
    let adultCount: Int
    let childCount: Int
    let infantCount: Int
    
    init(uid: String, createdTimeStamp: Date, baseFareTotal: Double, saleFareTotal: Double, saleTaxTotal: Double,
         saleTotal: Double, fareCalculation: String, latestTicketingTime: DateAndTimeZone, refundable: Bool,
         taxCountry: String, adultCount: Int, childCount: Int, infantCount: Int, departingFlightSegments: [FlightSegment], returningFlightSegments: [FlightSegment]? = nil) {
        self.uid = uid
        self.createdTimeStamp = createdTimeStamp
        self.saleTotal = saleTotal
        self.baseFareTotal = baseFareTotal
        self.saleFareTotal = saleFareTotal
        self.saleTaxTotal = saleTaxTotal
        self.fareCalculation = fareCalculation
        self.latestTicketingTime = latestTicketingTime
        self.refundable = refundable
        self.taxCountry = taxCountry
        self.adultCount = adultCount
        self.childCount = childCount
        self.infantCount = infantCount
        
        self.departingFlight = Flight(segments: departingFlightSegments)
        
        if let returningFlightSegments = returningFlightSegments {
            self.returningFlight = Flight(segments: returningFlightSegments)
        }
    }
    
    var shortDescription: String {
        return "\(departingFlight.originAirportCode)-\(departingFlight.destinationAirportCode)"
    }
    
    var isRoundTrip: Bool {
        return returningFlight != nil
    }
    
    var completeBookingCode: String {
        return isRoundTrip ? (departingFlight.bookingCode + " " + returningFlight!.bookingCode) : departingFlight.bookingCode
    }
    
    var passengerCountString: String {
        var passengerArray = [String]()
        if adultCount > 0 {
            passengerArray.append("\(adultCount) \(adultCount == 1 ? "Adult" : "Adults")")
        }
        
        if childCount > 0 {
            passengerArray.append("\(childCount) \(childCount == 1 ? "Child" : "Children")")
        }
        
        if infantCount > 0 {
            passengerArray.append("\(infantCount) \(infantCount == 1 ? "Infant" : "Infants")")
        }
        
        return passengerArray.joined(separator: ", ")
    }
    
    var passengerCount: Int {
        return [adultCount, childCount, infantCount].reduce(0, +)
    }
    
    mutating func longDescription() -> String {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let airportService = appDelegate.firebaseAirportService!
        if let origin = airportService.airport(withIdentifier: departingFlight.originAirportCode),
            let destination = airportService.airport(withIdentifier: departingFlight.destinationAirportCode) {
            return "\(origin.cityAndState) to \(destination.cityAndState)"
        }
        return ""
    }
}
