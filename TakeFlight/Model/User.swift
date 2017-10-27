//
//  User.swift
//  TakeFlight
//
//  Created by Justin Erickson on 10/27/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import Foundation

class User {
    
    let defaults = UserDefaults.standard
    
    var origin: String {
        get {
            return defaults.string(forKey: Constants.USER_ORIGIN_KEY)!
        }
        set {
            defaults.set(newValue, forKey: Constants.USER_ORIGIN_KEY)
        }
    }
    
    var destination: String {
        get {
            return defaults.string(forKey: Constants.USER_DESTINATION_KEY)!
        }
        set {
            defaults.set(newValue, forKey: Constants.USER_DESTINATION_KEY)
        }
    }
    
    var departureDate: Date {
        get {
            return defaults.object(forKey: Constants.USER_DEPARTURE_DATE_KEY) as! Date
        }
        set {
            defaults.set(newValue, forKey: Constants.USER_DEPARTURE_DATE_KEY)
        }
    }
    
    var returnDate: Date {
        get {
            return defaults.object(forKey: Constants.USER_RETURN_DATE_KEY) as! Date
        }
        set {
            defaults.set(newValue, forKey: Constants.USER_RETURN_DATE_KEY)
        }
    }
}
