//
//  Constants.swift
//  TakeFlight
//
//  Created by Justin Erickson on 10/1/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import Foundation
import Firebase

typealias JSONRepresentable = [String: Any]
typealias FlightDataContainer = (departure: FlightData, return: FlightData?)
typealias ErrorCompletionHandler = (Error?) -> Void

enum Constants {
    
    // MARK: Identifiers
    
    static let DATE_PICKER_VC = "DatePickerVC"
    static let AIRPORT_PICKER_VC = "AirportPickerVC"
    static let ROUND_TRIP_FLIGHT_DATA_CELL = "RoundTripFlightDataCell"
    static let ONE_WAY_FLIGHT_DATA_CELL = "OneWayFlightDataCell"
    static let DATE_PICKER_CELL = "DatePickerCell"
    static let AIRPORT_PICKER_CELL = "AirportPickerCell"
    static let MONTH_SECTION_HEADER_VIEW = "MonthSectionHeaderView"
    
    
    // MARK: Firebase
    
    static let DB_BASE = Database.database().reference()
    
    // MARK: User Defaults
    
    static let USER_ORIGIN_KEY = "userOriginKey"
    static let USER_DESTINATION_KEY = "userDestinationKey"
    static let USER_DEPARTURE_DATE_KEY = "userDepartureDateKey"
    static let USER_RETURN_DATE_KEY = "userReturnDateKey"
    static let USER_SEARCH_TYPE_KEY = "userSearchTypeKey"
}

