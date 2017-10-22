//
//  Constants.swift
//  TakeFlight
//
//  Created by Justin Erickson on 10/1/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import Foundation
import Firebase

enum Constants {
    
    // MARK: Identifiers
    
    static let ROUND_TRIP_FLIGHT_DATA_CELL = "RoundTripFlightDataCell"
    static let DATE_PICKER_CELL = "DatePickerCell"
    
    // MARK: Segues
    
    static let TO_DATE_PICKER = "ToDatePicker"
    
    // MARK: Firebase
    
    static let DB_BASE = Database.database().reference()
}

