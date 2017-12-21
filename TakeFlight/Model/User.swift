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
    private(set) var firstName: String?
    private(set) var lastName: String?
    private(set) var email: String
    private(set) var dateJoined: Date
    
    var dictionaryRepresentation: [String: Any] {
        let dictionary: [String: Any] = [
            "uid": uid as Any,
            "firstName": firstName as Any,
            "lastName": lastName as Any,
            "email": email as Any,
            "dateJoined": dateJoined
        ]
        return dictionary
    }
    
    // MARK: Lifecycle
    
    init(uid: String, firstName: String?, lastName: String?, email: String, dateJoined: Date) {
        self.uid = uid
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.dateJoined = dateJoined
    }
    
    convenience init(uid: String, email: String) {
        self.init(uid: uid, firstName: "", lastName: "", email: email, dateJoined: Date())
    }
    
    convenience init?(data: [String: Any]) {
        guard let uid = data["uid"] as? String else { return nil }
        guard let dateJoined = data["dateJoined"] as? Date else { return nil }
        guard let email = data["email"] as? String else { return nil }
        let firstName = data["firstName"] as? String
        let lastName = data["lastName"] as? String
        
        self.init(uid: uid, firstName: firstName, lastName: lastName, email: email, dateJoined: dateJoined)
    }
}
