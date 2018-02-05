//
//  QPXExpress+Request.swift
//  TakeFlight
//
//  Created by Justin Erickson on 11/28/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import Foundation

protocol QPXExpressOptions {
    var key: String { get }
    var value: Any { get }
}

extension QPXExpress {
    
    // MARK: Types
    
//    enum PassengerOptions: QPXExpressOptions {
//        case childCount(Int)
//        case infantInLapCount(Int)
//        case seniorCount(Int)
//
//        var key: String {
//            switch self {
//            case .childCount: return "childCount"
//            case .infantInLapCount: return "infantInLapCount"
//            case .seniorCount: return "seniorCount"
//            }
//        }
//
//        var value: Any {
//            switch self {
//            case .childCount(let value): return value as Int
//            case .infantInLapCount(let value): return value as Int
//            case .seniorCount(let value): return value as Int
//            }
//        }
//    }
    
    enum SliceOptions: QPXExpressOptions {
        case maxStops(Int)
        case maxConnectionDuration(Int)
        case prefferedCabin(String)
        
        var key: String {
            switch self {
            case .maxStops: return "maxStops"
            case .maxConnectionDuration: return "maxConnectionDuration"
            case .prefferedCabin: return "prefferedCabin"
            }
        }
        
        var value: Any {
            switch self {
            case .maxStops(let value): return value as Int
            case .maxConnectionDuration(let value): return value as Int
            case .prefferedCabin(let value): return value as String
            }
        }
    }
    
    enum RequestOptions: QPXExpressOptions {
        case maxPrice(String)
        case refundable(String)
        
        var key: String {
            switch self {
            case .maxPrice: return "maxPrice"
            case .refundable: return "refundable"
            }
        }
        
        var value: Any {
            switch self {
            case .maxPrice(let value): return value as String
            case .refundable(let value): return value as String
            }
        }
    }
    
    struct Request {
        struct Passengers {
            let kind = "qpxexpress#passengerCounts"
            let adultCount: Int
            let childCount: Int
            let infantCount: Int
//            var options = [String: Any]()
            
            fileprivate var dictionaryRepresentation: JSONRepresentable {
//                return [
//                    "kind": kind,
//                    "adultCount": adultCount
//                    ].merging(options) { (current, _) -> Any in
//                        return current
//                }
                
                return [
                    "kind": kind,
                    "adultCount": adultCount,
                    "childCount": childCount,
                    "infantCount": infantCount
                ]
            }
        }
        
        struct Slice {
            let kind = "qpxexpress#sliceInput"
            let origin: String
            let destination: String
            let date: String
            var options = [String: Any]()
            
            fileprivate var dictionaryRepresentation: JSONRepresentable {
                return [
                    "kind": kind,
                    "origin": origin,
                    "destination": destination,
                    "date": date
                    ].merging(options, uniquingKeysWith: { (current, _) -> Any in
                        return current
                    })
            }
        }
        
        // MARK: Properties
        lazy var url: URL = {
            let apiKey = KeyManager.valueForAPIKey(APIKey.QPXExpressAPIKey.rawValue)
            return URL(string: "https://www.googleapis.com/qpxExpress/v1/trips/search?key=\(apiKey)")!
        }()
        
        let headers = ["Content-Type": "application/json"]
        
        var passengers: Passengers
        var slice: [Slice]
        var options = [String: Any]()
        
        var dictionaryRepresentaion: JSONRepresentable {
            var sliceArray = [JSONRepresentable]()
            self.slice.forEach { (slice) in
                sliceArray.append(slice.dictionaryRepresentation)
            }
            return [
                "request": [
                    "passengers": passengers.dictionaryRepresentation,
                    "slice": sliceArray
                    ].merging(options, uniquingKeysWith: { (current, _) -> Any in
                        return current
                    })
            ]
        }
        
        init(adultCount: Int, childCount: Int, infantCount: Int, origin: String, destination: String, date: Date) {
            self.passengers = Passengers(adultCount: adultCount, childCount: childCount, infantCount: infantCount)
            self.slice = [Slice(origin: origin, destination: destination, date: date.toQPXExpressRequestString(), options: [:])]
        }
        
        init(adultCount: Int, childCount: Int, infantCount: Int, origin: String, destination: String, date: Date, options: [QPXExpressOptions]) {
            self.passengers = Passengers(adultCount: adultCount, childCount: childCount, infantCount: infantCount)
            self.slice = [Slice(origin: origin, destination: destination, date: date.toQPXExpressRequestString(), options: [:])]
            add(options: options)
        }
        
        // MARK: Convenience
        
        mutating func add(options: [QPXExpressOptions]) {
            for option in options {
                if option is SliceOptions {
                    for index in 0..<self.slice.count {
                        self.slice[index].options[option.key] = option.value
                    }
                } else if option is RequestOptions {
                    self.options[option.key] = option.value
                }
            }
        }
        
        mutating func add(returnDate: Date, withOptions options: [QPXExpressOptions]? = nil) {
            guard let departureFlight = self.slice.first else { return }
            let returnFlight = Slice(origin: departureFlight.destination, destination: departureFlight.origin, date: returnDate.toQPXExpressRequestString(), options: [:])
            self.slice.append(returnFlight)
            if let options = options {
                add(options: options)
            }
        }
    }
    
    // MARK: QPXExpress Factory Methods
    
    func makeQPXRequest(adultCount: Int, childCount: Int, infantCount: Int, from origin: Airport, to destination: Airport, departing departureDate: Date, returning returnDate: Date?, withOptions options: [QPXExpressOptions]? = nil) -> Request {
        var request = Request(adultCount: adultCount, childCount: childCount, infantCount: infantCount, origin: origin.iata, destination: destination.iata, date: departureDate)
        if let returnDate = returnDate {
            request.add(returnDate: returnDate)
        }
        
        if let options = options {
            request.add(options: options)
        }
        return request
    }
    
    func makeQPXRequest(withUserRequest userRequest: FlightSearchRequest) -> Request? {
        guard let origin = userRequest.origin else { return nil }
        guard let destination = userRequest.destination else { return nil }
        guard let departureDate = userRequest.departureDate else { return nil }
        
        
        
        return makeQPXRequest(adultCount: userRequest.numberOfAdultPassengers,
                              childCount: userRequest.numberOfChildPassengers,
                              infantCount: userRequest.numberOfInfantPassengers,
                              from: origin,
                              to: destination,
                              departing: departureDate,
                              returning: userRequest.returnDate)
    }
}
