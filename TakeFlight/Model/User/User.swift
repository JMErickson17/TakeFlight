//
//  User.swift
//  TakeFlight
//
//  Created by Justin Erickson on 12/20/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import Foundation

class User {
    
    // MARK: Properties
    
    private(set) var uid: String
    private(set) var email: String
    private(set) var dateJoined: Date
    private(set) var firstName: String?
    private(set) var lastName: String?
    private(set) var phoneNumber: String?
    private(set) var preferredCurrency: String?
    private(set) var preferredLanguage: String?
    private(set) var billingCountry: String?
//    private(set) var searchHistory: [UserSearchRequest]?
    
    var fullName: String? {
        if let firstName = firstName, let lastName = lastName {
            return "\(firstName) \(lastName)"
        }
        return nil
    }
    
    
    var dictionaryRepresentation: [String: Any] {
        let dictionary: [String: Any] = [
            "uid": uid as Any,
            "email": email as Any,
            "dateJoined": dateJoined,
            "firstName": firstName as Any,
            "lastName": lastName as Any,
            "phoneNumber": phoneNumber as Any,
            "preferredCurrency": preferredCurrency as Any,
            "preferredLanguage": preferredLanguage as Any,
            "billingCountry": billingCountry as Any
        ]
        return dictionary
    }
    
    // MARK: Lifecycle
    
    init(uid: String, email: String, dateJoined: Date, firstName: String?, lastName: String?, phoneNumber: String?, preferredCurrency: String?, preferredLanguage: String?, billingCountry: String?) {
        self.uid = uid
        self.email = email
        self.dateJoined = dateJoined
        self.firstName = firstName
        self.lastName = lastName
        self.phoneNumber = phoneNumber
        self.preferredCurrency = preferredCurrency
        self.preferredLanguage = preferredLanguage
        self.billingCountry = billingCountry
    }
    
    convenience init(uid: String, email: String) {
        self.init(uid: uid, email: email, dateJoined: Date(), firstName: "", lastName: "", phoneNumber: "", preferredCurrency: "", preferredLanguage: "", billingCountry: "")
    }
    
    convenience init?(data: [String: Any]) {
        guard let uid = data["uid"] as? String else { return nil }
        guard let dateJoined = data["dateJoined"] as? Date else { return nil }
        guard let email = data["email"] as? String else { return nil }
        let firstName = data["firstName"] as? String
        let lastName = data["lastName"] as? String
        let phoneNumber = data["phoneNumber"] as? String
        let preferredCurrency = data["preferredCurrency"] as? String
        let preferredLanguage = data["preferredLanguage"] as? String
        let billingCountry = data["billingCountry"] as? String
        
        self.init(uid: uid, email: email,dateJoined: dateJoined, firstName: firstName, lastName: lastName, phoneNumber: phoneNumber, preferredCurrency: preferredCurrency, preferredLanguage: preferredLanguage, billingCountry: billingCountry)
    }
}
