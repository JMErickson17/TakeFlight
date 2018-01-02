//
//  User.swift
//  TakeFlight
//
//  Created by Justin Erickson on 12/20/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import UIKit

class User {
    
    // MARK: Properties
    
    private(set) var uid: String
    private(set) var email: String
    private(set) var dateJoined: Date
    private(set) var firstName: String?
    private(set) var lastName: String?
    private(set) var phoneNumber: String?
    private(set) var profileImageURL: URL?
    private(set) var profileImage: UIImage?
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
            "profileImageURL": profileImageURL?.absoluteString as Any,
            "preferredCurrency": preferredCurrency as Any,
            "preferredLanguage": preferredLanguage as Any,
            "billingCountry": billingCountry as Any
        ]
        return dictionary
    }
    
    // MARK: Lifecycle
    
    init(uid: String, email: String, dateJoined: Date, firstName: String?, lastName: String?,
         phoneNumber: String?, profileImageURL: URL?, preferredCurrency: String?, preferredLanguage: String?, billingCountry: String?) {
        self.uid = uid
        self.email = email
        self.dateJoined = dateJoined
        self.firstName = firstName
        self.lastName = lastName
        self.phoneNumber = phoneNumber
        self.profileImageURL = profileImageURL
        self.preferredCurrency = preferredCurrency
        self.preferredLanguage = preferredLanguage
        self.billingCountry = billingCountry
        
        DispatchQueue.global().async {
            self.downloadUserProfileImage(forUID: uid)
        }
    }
    
    convenience init(uid: String, email: String) {
        self.init(uid: uid, email: email, dateJoined: Date(), firstName: nil, lastName: nil, phoneNumber: nil,
                  profileImageURL: nil, preferredCurrency: nil, preferredLanguage: nil, billingCountry: nil)
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
        
        var profileImageURL: URL?
        if let profileImageURLString = data["profileImageURL"] as? String {
            profileImageURL = URL(string: profileImageURLString)
        }
        
        self.init(uid: uid,
                  email: email,
                  dateJoined: dateJoined,
                  firstName: firstName,
                  lastName: lastName,
                  phoneNumber: phoneNumber,
                  profileImageURL: profileImageURL,
                  preferredCurrency: preferredCurrency,
                  preferredLanguage: preferredLanguage,
                  billingCountry: billingCountry
        )
    }
    
    // MARK: Convenience
    
    private func downloadUserProfileImage(forUID uid: String) {
        FirebaseStorageService.instance.download(userProfileImageWithUID: uid) { (imageData, error) in
            if let error = error { print(error) }
            if let imageData = imageData, let profileImage = UIImage(data: imageData) {
                self.profileImage = profileImage
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: .userPropertiesDidChange, object: nil)
                }
            }
        }
    }
}
