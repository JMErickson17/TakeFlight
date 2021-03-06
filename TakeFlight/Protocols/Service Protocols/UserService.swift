//
//  UserService.swift
//  TakeFlight
//
//  Created by Justin Erickson on 1/16/18.
//  Copyright © 2018 Justin Erickson. All rights reserved.
//

import UIKit
import Firebase
import RxSwift
import RxCocoa

protocol UserService {
    
    var currentUser: Variable<User?> { get }
    var profileImage: Variable<UIImage> { get }
    var savedFlights: Variable<[FlightData]> { get }
    
    func createNewUser(withEmail email: String, password: String, completion: @escaping (User?, Error?) -> Void)
    func signInUser(withEmail email: String, password: String, completion: AuthResultCallback?)
    func signOutCurrentUser(completion: ErrorCompletionHandler?)
    func updateEmailForCurrentUser(to email: String, completion: @escaping (Bool, Error?) -> Void)
    func sendVerificationEmailToCurrentUser(completion: @escaping (Bool, Error?) -> Void)
    func saveToCurrentUser(updatedProperties: [UpdatableUserProperties: Any], completion: ErrorCompletionHandler?)
    func saveToCurrentUser(profileImage image: UIImage, completion: ErrorCompletionHandler?)
    func save(searchRequest: FlightSearchRequest)
    func saveToCurrentUser(flightData: FlightData, completion: ErrorCompletionHandler?)
    func getSavedFlightsForCurrentUser(completion: @escaping ([FlightData]?, Error?) -> Void)
    func delete(savedFlightWithUID uid: String, completion: ErrorCompletionHandler?)
    func deleteProfileImageForCurrentUser(completion: @escaping ErrorCompletionHandler)
    func clearCurrentUserSearchHistory(completion: ErrorCompletionHandler?)
}
