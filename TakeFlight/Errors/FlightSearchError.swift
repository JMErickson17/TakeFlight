//
//  FlightSearchError.swift
//  TakeFlight
//
//  Created by Justin Erickson on 1/16/18.
//  Copyright © 2018 Justin Erickson. All rights reserved.
//

import Foundation

enum FlightSearchError: Error {
    case invalidSearchData
    case invalidRequest
    case invalidReponse
    case invalidUserSearchRequest
    case responseExpired
    case searchCancelled
}
