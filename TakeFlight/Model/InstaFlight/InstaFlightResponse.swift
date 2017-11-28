//
//  InstaFlightResponse.swift
//  TakeFlight
//
//  Created by Justin Erickson on 11/15/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import Foundation

class InstaFlightResponse {
    
    var pricedItineraries = [String]()
    var origin: String?
    var destination: String?
    var returnDateTime: String?
    var departureDateTime: String?
    var links = [IFLink]()
}
