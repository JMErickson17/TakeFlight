//
//  UserSearchRequest.swift
//  TakeFlight
//
//  Created by Justin Erickson on 12/21/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import Foundation

struct UserSearchRequest {
    var timeStamp: Date
    var origin: Airport
    var destination: Airport
    var departureDate: Date
    var returnDate: Date?
    
    var dictionaryRepresentation: [String: Any] {
        return [
            "timeStamp": timeStamp,
            "origin": origin.identifier,
            "destination": destination.identifier,
            "departureDate": departureDate,
            "returnDate": returnDate as Any
        ]
    }
}
