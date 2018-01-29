//
//  FlightData+Flight.swift
//  TakeFlight
//
//  Created by Justin Erickson on 1/29/18.
//  Copyright © 2018 Justin Erickson. All rights reserved.
//

import UIKit

extension FlightData {
    
    struct Flight: Codable {
        
        let segments: [FlightSegment]
        
        enum CodingKeys: String, CodingKey {
            case segments
        }
        
        private let carrierImages: [String: UIImage] = [
            "AS": #imageLiteral(resourceName: "AlaskaAirlinesLogo"),
            "B6": #imageLiteral(resourceName: "JetBlueAirlinesLogo"),
            "F9": #imageLiteral(resourceName: "FrontierAirlinesLogo"),
            "NK": #imageLiteral(resourceName: "SpiritAirlinesLogo"),
            "SY": #imageLiteral(resourceName: "SunCountryAirlinesLogo"),
            "UA": #imageLiteral(resourceName: "UnitedAirlinesLogo"),
            "DL": #imageLiteral(resourceName: "DeltaAirlinesLogo"),
            "WN": #imageLiteral(resourceName: "SouthwestAirlinesLogo"),
            "AA": #imageLiteral(resourceName: "AmericanAirlinesLogo"),
            "VX": #imageLiteral(resourceName: "VirginAirlinesLogo"),
            "VS": #imageLiteral(resourceName: "VirginAirlinesLogo")
        ]
        
        var carrier: Carrier {
            return segments[0].carrier
        }
        
        var carrierLogo: UIImage? {
            return carrierImages[segments[0].carrier.code]
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
            return segments.map { $0.carrier.code + $0.flightNumber }.joined(separator: " ")
        }
        
        var segmentDescription: String {
            var segmentArray = [String]()
            for segment in segments {
                segmentArray.append("\(segment.originAirportCode)-\(segment.destinationAirportCode)")
            }
            return segmentArray.joined(separator: ", ")
        }
        
        var originAirportCode: String {
            return (segments.first?.originAirportCode) ?? ""
        }
        
        var destinationAirportCode: String {
            return (segments.last?.destinationAirportCode) ?? ""
        }
    }
}
