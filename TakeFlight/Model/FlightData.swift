//
//  FlightData.swift
//  TakeFlight
//
//  Created by Justin Erickson on 10/1/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import UIKit
import SwiftyJSON

struct FlightData {
    
/*
     FlightSegment
 */
    struct FlightSegment {
        var id: String
        var aircraft: Aircraft
        var carrier: Carrier
        var flightNumber: String
        var carrierIcon: String
        var arrivalTime: Date
        var departureTime: Date
        var origin: Airport
        var destination: Airport
        var duration: Int
        var cabin: String
        var bookingCode: String
        var mileage: Int
    }

/*
     Aircraft
 */
    struct Aircraft {
        public private(set) var code: String
        public private(set) var name: String
        
        static func convertToAircraft(fromArray array: [JSONRepresentable]) -> [Aircraft]? {
            var aircraftArray = [Aircraft]()
            
            for element in array {
                guard let code = element["code"] as? String else { continue }
                guard let name = element["name"] as? String else { continue }
                aircraftArray.append(Aircraft(code: code, name: name))
            }
            return aircraftArray.isEmpty ? nil : aircraftArray
        }
    }
    
/*
     Airport
 */
    struct Airport {
        public private(set) var code: String
        public private(set) var city: String
        public private(set) var name: String
        
        static func convertToAirport(fromArray array: [JSONRepresentable]) -> [Airport]? {
            var airportArray = [Airport]()
            
            for element in array {
                guard let code = element["code"] as? String else { continue }
                guard let city = element["city"] as? String else { continue }
                guard let name = element["name"] as? String else { continue }
                airportArray.append(Airport(code: code, city: city, name: name))
            }
            return airportArray.isEmpty ? nil : airportArray
        }
    }
    
/*
     Carrier
 */
    struct Carrier {
        public private(set) var code: String
        public private(set) var name: String
        
        static func convertToCarrier(fromArray array: [JSONRepresentable]) -> [Carrier]? {
            var carrierArray = [Carrier]()
            
            for element in array {
                guard let code = element["code"] as? String else { continue }
                guard let name = element["name"] as? String else { continue }
                carrierArray.append(Carrier(code: code, name: name))
            }
            return carrierArray.isEmpty ? nil : carrierArray
        }
    }
    
    public private(set) var id: String
    public private(set) var bookingCode: String
    public private(set) var saleTotal: String
    public private(set) var flightSegments: [FlightSegment]
    
    // TODO: Convert to computed properties
//    public private(set) var duration: Int
//    public private(set) var origin: String
//    public private(set) var destination: String
    // TODO: Convert to Date
//    public private(set) var departureTime: String
//    public private(set) var arrivalTime: String
    
    
    // MARK: Lifetime
    
    static func parseQPXExpressToAirports(fromData data: JSONRepresentable) -> [FlightData]? {
        guard let trips = data["trips"] as? JSONRepresentable else { return nil }
        guard let tripData = trips["data"] as? JSONRepresentable else { return nil }
        guard let aircrafts = Aircraft.convertToAircraft(fromArray: tripData["aircraft"] as! [JSONRepresentable]) else { return nil }
        guard let airports = Airport.convertToAirport(fromArray: tripData["airport"] as! [JSONRepresentable]) else { return nil }
        guard let carriers = Carrier.convertToCarrier(fromArray: tripData["carrier"] as! [JSONRepresentable]) else { return nil }
        guard let tripOption = trips["tripOption"] as? [JSONRepresentable] else { return nil }
        
        var flightDataArray = [FlightData]()
        
        
        for trip in tripOption {
            guard let id = trip["id"] as? String else { continue }
            guard let saleTotal = trip["saleTotal"] as? String else { continue }
            guard let slices = trip["slice"] as? [JSONRepresentable] else { continue }
        
            var flightSegmentsArray = [FlightSegment]()
            
            for slice in slices {
                guard let segments = slice["segment"] as? [JSONRepresentable] else { continue }
                
                for segment in segments {
                    guard let segmentId = segment["id"] as? String else { continue }
                    guard let bookingCode = segment["bookingCode"] as? String else { continue }
                    guard let cabin = segment["cabin"] as? String else { continue }
                    guard let flight = segment["flight"] as? JSONRepresentable else { continue }
                    guard let carrierId = flight["carrier"] as? String else { continue }
                    guard let flightNumber = flight["number"] as? String else { continue }
                    
                    guard let leg = segment["leg"] as? [JSONRepresentable] else { continue }
                    guard let legObject = leg.first else { continue }
                    guard let legAircraftId = legObject["aircraft"] as? String else { continue }
                    guard let legArrivalTimeString = legObject["arrivalTime"] as? String else { continue }
                    guard let legDepartureTimeString = legObject["departureTime"] as? String else { continue }
                    guard let legOriginId = legObject["origin"] as? String else { continue }
                    guard let legDestinationId = legObject["destination"] as? String else { continue }
                    guard let legDuration = legObject["duration"] as? Int else { continue }
                    guard let legMileage = legObject["mileage"] as? Int else { continue }
                    
                    guard let carrier = carriers.first(where: { $0.code == carrierId }) else { continue }
                    guard let aircraft = aircrafts.first(where: { $0.code == legAircraftId}) else { continue }
                    guard let legOrigin = airports.first(where: { $0.code == legOriginId }) else { continue }
                    guard let legDestination = airports.first(where: { $0.code == legDestinationId }) else { continue }
                    guard let legDepartureTime = legDepartureTimeString.qpxExpressStringToDate() else { continue }
                    guard let legArrivalTime = legArrivalTimeString.qpxExpressStringToDate() else { continue }

                    let flightSegment = FlightSegment(id: segmentId, aircraft: aircraft, carrier: carrier, flightNumber: flightNumber, carrierIcon: carrierId, arrivalTime: legArrivalTime, departureTime: legDepartureTime, origin: legOrigin, destination: legDestination, duration: legDuration, cabin: cabin, bookingCode: bookingCode, mileage: legMileage)

                    flightSegmentsArray.append(flightSegment)
                }
            }

            let flightData = FlightData(id: id, bookingCode: "", saleTotal: saleTotal, flightSegments: flightSegmentsArray)
            flightDataArray.append(flightData)
        }
        return flightDataArray
    }
}
