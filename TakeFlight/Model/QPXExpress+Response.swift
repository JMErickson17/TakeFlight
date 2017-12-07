//
//  QPXExpress+Response.swift
//  TakeFlight
//
//  Created by Justin Erickson on 11/28/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import Foundation

extension QPXExpress {
    
    struct Response: Decodable {
        
        struct Trips: Decodable {
            private(set) var data: Data
            private(set) var requestId: String
            private(set) var tripOption: [TripOption]
            
            enum CodingKeys: String, CodingKey {
                case data
                case requestId
                case tripOption
            }
        }
        
        struct Data: Decodable {
            private(set) var airport: [Airport]
            private(set) var city: [City]
            private(set) var aircraft: [Aircraft]
            private(set) var tax: [Tax]
            private(set) var carrier: [Carrier]
            
            enum CodingKeys: String, CodingKey {
                case airport
                case city
                case aircraft
                case tax
                case carrier
            }
        }
        
        struct Aircraft: Decodable {
            private(set) var kind: String
            private(set) var code: String
            private(set) var name: String
        }
        
        struct Airport: Decodable {
            private(set) var kind: String
            private(set) var code: String
            private(set) var city: String
            private(set) var name: String
        }
        
        struct Carrier: Decodable {
            private(set) var kind: String
            private(set) var code: String
            private(set) var name: String
        }
        
        struct City: Decodable {
            private(set) var kind: String
            private(set) var code: String
            private(set) var name: String
        }
        
        struct Tax: Decodable {
            private(set) var kind: String
            private(set) var id: String
            private(set) var name: String
        }
        
        struct TripOption: Decodable {
            private(set) var saleTotal: String
            private(set) var id: String
            private(set) var slice: [Slice]
            private(set) var pricing: [Pricing]
            
            enum CodingKeys: String, CodingKey {
                case saleTotal
                case id
                case slice
                case pricing
            }
        }
        
        struct Slice: Decodable {
            private(set) var duration: Int
            private(set) var segment: [Segment]
            
            enum CodingKeys: String, CodingKey {
                case duration
                case segment
            }
        }
        
        struct Segment: Decodable {
            private(set) var id: String
            private(set) var flight: Flight
            private(set) var duration: Int
            private(set) var cabin: String
            private(set) var bookingCode: String
            private(set) var bookingCodeCount: Int
            private(set) var marriedSegmentGroup: String
            private(set) var subjectToGovernmentApproval: Bool?
            private(set) var leg: [Leg]
            private(set) var connectionDuration: Int?
            
            enum CodingKeys: String, CodingKey {
                case id
                case flight
                case duration
                case cabin
                case bookingCode
                case bookingCodeCount
                case marriedSegmentGroup
                case subjectToGovernmentApproval
                case leg
                case connectionDuration
            }
        }
        
        struct Flight: Decodable {
            private(set) var carrier: String
            private(set) var number: String
        }
        
        struct Leg: Decodable {
            private(set) var id: String
            private(set) var aircraft: String
            private(set) var arrivalTime: String
            private(set) var departureTime: String
            private(set) var origin: String
            private(set) var originTerminal: String?
            private(set) var destination: String
            private(set) var destinationTerminal: String?
            private(set) var duration: Int
            private(set) var onTimePerformance: Int?
            private(set) var mileage: Int
            private(set) var meal: String?
            private(set) var secure: Bool
            private(set) var connectionDuration: Int?
            
            enum CodingKeys: String, CodingKey {
                case id
                case aircraft
                case arrivalTime
                case departureTime
                case origin
                case originTerminal
                case destination
                case destinationTerminal
                case duration
                case onTimePerformance
                case mileage
                case meal
                case secure
                case connectionDuration
            }
        }
        
        struct Pricing: Decodable {
            private(set) var fare: [Fare]
            private(set) var baseFareTotal: String
            private(set) var saleFareTotal: String
            private(set) var saleTaxTotal: String
            private(set) var saleTotal: String
            private(set) var fareCalculation: String
            private(set) var latestTicketingTime: String
            private(set) var tax: [TaxInfo]
            private(set) var refundable: Bool?
            
            enum CodingKeys: String, CodingKey {
                case fare
                case baseFareTotal
                case saleFareTotal
                case saleTaxTotal
                case saleTotal
                case fareCalculation
                case latestTicketingTime
                case tax
                case refundable
            }
        }
        
        struct Fare: Decodable {
            private(set) var id: String
            private(set) var carrier: String
            private(set) var origin: String
            private(set) var destination: String
            private(set) var basisCode: String
            
            enum CodingKeys: String, CodingKey {
                case id
                case carrier
                case origin
                case destination
                case basisCode
            }
        }
        
        struct TaxInfo: Decodable {
            private(set) var id: String
            private(set) var chargeType: String
            private(set) var code: String
            private(set) var country: String
            private(set) var salePrice: String
            
            enum CodingKeys: String, CodingKey {
                case id
                case chargeType
                case code
                case country
                case salePrice
            }
        }
        
        private(set) var trips: Trips
        
        enum CodingKeys: String, CodingKey {
            case trips
        }
    }
}
