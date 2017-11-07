//
//  User.swift
//  TakeFlight
//
//  Created by Justin Erickson on 10/27/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import Foundation

final class UserDataService {
    
    static let instance = UserDataService()
    private init() {}
    
    private let defaults = UserDefaults.standard
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    var origin: Airport? {
        get {
            if let data: Data = defaults.object(forKey: Constants.USER_ORIGIN_KEY) as? Data {
                return try! decoder.decode(Airport.self, from: data)
            }
            return nil
        }
        set {
            let data = try? encoder.encode(newValue)
            defaults.set(data, forKey: Constants.USER_ORIGIN_KEY)
        }
    }
    
    var destination: Airport? {
        get {
            if let data: Data = defaults.object(forKey: Constants.USER_DESTINATION_KEY) as? Data {
                return try! decoder.decode(Airport.self, from: data)
            }
            return nil
        }
        set {
            let data = try? encoder.encode(newValue)
            defaults.set(data, forKey: Constants.USER_DESTINATION_KEY)
        }
    }
    
    var departureDate: Date? {
        get {
            return defaults.object(forKey: Constants.USER_DEPARTURE_DATE_KEY) as? Date
        }
        set {
            defaults.set(newValue, forKey: Constants.USER_DEPARTURE_DATE_KEY)
        }
    }
    
    var returnDate: Date? {
        get {
            return defaults.object(forKey: Constants.USER_RETURN_DATE_KEY) as? Date
        }
        set {
            defaults.set(newValue, forKey: Constants.USER_RETURN_DATE_KEY)
        }
    }
    
    var searchType: String? {
        get {
            return defaults.string(forKey: Constants.USER_SEARCH_TYPE_KEY)
        }
        set {
            defaults.set(newValue, forKey: Constants.USER_SEARCH_TYPE_KEY)
        }
    }
}
