//
//  UserService.swift
//  TakeFlight
//
//  Created by Justin Erickson on 1/16/18.
//  Copyright © 2018 Justin Erickson. All rights reserved.
//

import UIKit
import Firebase

protocol UserService {
    
    var currentUser: User? { get }
    
    func createNewUser(withEmail email: String, password: String, completion: @escaping (User?, Error?) -> Void)
    func signInUser(withEmail email: String, password: String, completion: AuthResultCallback?)
    func signOutCurrentUser(completion: ErrorCompletionHandler?)
    func updateEmailForCurrentUser(to email: String, completion: @escaping (Bool, Error?) -> Void)
    func sendVerificationEmailToCurrentUser(completion: @escaping (Bool, Error?) -> Void)
    func saveToCurrentUser(updatedProperties: [UpdatableUserProperties: Any], completion: ErrorCompletionHandler?)
    func saveToCurrentUser(profileImage image: UIImage, completion: ErrorCompletionHandler?)
    func saveToCurrentUser(userSearchRequest request: FlightSearchRequest, completion: ErrorCompletionHandler?)
    func saveToCurrentUser(flightData: FlightData, completion: ErrorCompletionHandler?)
    func getSavedFlightsForCurrentUser(completion: @escaping ([FlightData]?, Error?) -> Void)
    func clearCurrentUserSearchHistory(completion: ErrorCompletionHandler?)
}
