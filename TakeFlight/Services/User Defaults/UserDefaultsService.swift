//
//  UserDefaultsService.swift
//  TakeFlight
//
//  Created by Justin Erickson on 1/16/18.
//  Copyright © 2018 Justin Erickson. All rights reserved.
//

import Foundation

class UserDefaultsService {
    
    // MARK: Singleton
    
    static let instance = UserDefaultsService()
    private init() {}
    
    // MARK: Properties
    
    private var defaults: UserDefaults {
        return UserDefaults.standard
    }
    
    private var encoder: JSONEncoder {
        return JSONEncoder()
    }
    
    private var decoder: JSONDecoder {
        return JSONDecoder()
    }
    
    // MARK: UserDefaults Properties
    
    var origin: Airport? {
        get {
            if let data: Data = defaults.object(forKey: UserDefaults.Keys.UserOrigin) as? Data {
                return try? decoder.decode(Airport.self, from: data)
            }
            return nil
        }
        set {
            let data = try? encoder.encode(newValue)
            defaults.set(data, forKey: UserDefaults.Keys.UserOrigin)
        }
    }
    
    var destination: Airport? {
        get {
            if let data: Data = defaults.object(forKey: UserDefaults.Keys.UserDestination) as? Data {
                return try? decoder.decode(Airport.self, from: data)
            }
            return nil
        }
        set {
            let data = try? encoder.encode(newValue)
            defaults.set(data, forKey: UserDefaults.Keys.UserDestination)
        }
    }
    
    var departureDate: Date? {
        get {
            return defaults.object(forKey: UserDefaults.Keys.UserDepartureDate) as? Date
        }
        set {
            defaults.set(newValue, forKey: UserDefaults.Keys.UserDepartureDate)
        }
    }
    
    var returnDate: Date? {
        get {
            return defaults.object(forKey: UserDefaults.Keys.UserReturnDate) as? Date
        }
        set {
            defaults.set(newValue, forKey: UserDefaults.Keys.UserReturnDate)
        }
    }
    
    var searchType: SearchType {
        get {
            if let searchType = defaults.object(forKey: UserDefaults.Keys.SearchType) as? String {
                return SearchType(rawValue: searchType) ?? .oneWay
            }
            return .oneWay
        }
        set {
            defaults.set(newValue.rawValue, forKey: UserDefaults.Keys.SearchType)
        }
    }
}
