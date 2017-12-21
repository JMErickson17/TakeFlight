//
//  UserSearchRequest.swift
//  TakeFlight
//
//  Created by Justin Erickson on 12/21/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import Foundation

struct UserSearchRequest {
    var departureDate: Date?
    var returnDate: Date?
    var origin: String
    var destination: String
}
