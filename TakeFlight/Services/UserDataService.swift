//
//  User.swift
//  TakeFlight
//
//  Created by Justin Erickson on 10/27/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import Foundation
import Firebase

final class UserDataService {
    
    static let instance = UserDataService()
    
    // MARK: Properties
    
    var currentUser: User?
    
    private var handleAuthStateDidChange: AuthStateDidChangeListenerHandle?
    
    private var database: Firestore {
        return Firestore.firestore()
    }
    
    private var usersCollectionRef: CollectionReference {
        return database.collection("users")
    }

    // MARK: Lifecycle
    
    private init() {
        addAuthListener()
    }
    
    deinit {
        removeAuthListener()
    }
    
    // MARK: Authentication
    
    private func addAuthListener() {
        handleAuthStateDidChange = Auth.auth().addStateDidChangeListener({ (auth, firUser) in
            if let firUser = firUser {
                self.getUser(withUID: firUser.uid, completion: { (user, error) in
                    if let _ = error { return /* Log Error */ }
                    if let user = user {
                        self.currentUser = user
                        NotificationCenter.default.post(name: .authStatusDidChange, object: user)
                    }
                })
            } else {
                self.currentUser = nil
                NotificationCenter.default.post(name: .authStatusDidChange, object: nil)
            }
        })
    }
    
    private func removeAuthListener() {
        if let handleAuthStateDidChange = handleAuthStateDidChange {
            Auth.auth().removeStateDidChangeListener(handleAuthStateDidChange)
        }
    }
    
    func createNewUser(withEmail email: String, password: String, completion: @escaping (User?, Error?) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                if let error = error { return completion(nil, error) }
                
                if let user = user {
                    let newUser = User(uid: user.uid, email: user.email ?? "")
                    self.saveUserToDatabase(newUser, completion: { error in
                        if let error = error { return completion(nil, error) }
                        DispatchQueue.main.async {
                            completion(newUser, nil)
                        }
                    })
                }
            })
        }
    }
    
    func signInUser(withEmail email: String, password: String, completion: AuthResultCallback? = nil) {
        DispatchQueue.global(qos: .userInitiated).async {
            Auth.auth().signIn(withEmail: email, password: password, completion: completion)
        }
    }
    
    func signOutCurrentUser() throws {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch {
            throw error
        }
    }
    
    func updateEmailForCurrentUser(to email: String, completion: @escaping (Bool, Error?) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            Auth.auth().currentUser?.updateEmail(to: email, completion: { error in
                DispatchQueue.main.async {
                    if let error = error { return completion(false, error) }
                    completion(true, nil)
                }
            })
        }
    }
    
    func sendVerificationEmailToCurrentUser(completion: @escaping (Bool, Error?) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            Auth.auth().currentUser?.sendEmailVerification(completion: { error in
                DispatchQueue.main.async {
                    if let error = error { return completion(false, error) }
                    completion(true, nil)
                }
            })
        }
    }
    
    // MARK: Firestore
    
    private func saveUserToDatabase(_ user: User, completion: ((Error?) -> Void)?) {
        usersCollectionRef.document(user.uid).setData(user.dictionaryRepresentation, completion: completion)
    }
    
    private func getUser(withUID uid: String, completion: @escaping (User?, Error?) -> Void) {
        DispatchQueue.global().async {
            self.usersCollectionRef.document(uid).getDocument { (document, error) in
                if let error = error { return completion(nil, error) }
                if let document = document {
                    guard document.exists else { return completion(nil, nil /* Throw document doesnt exist error */) }
                    let documentData = document.data()
                    if let user = User(data: documentData) {
                        completion(user, nil)
                    }
                }
            }
        }
    }
    
    func clearCurrentUserSearchHistory(completion: ((Error?) -> Void)?) {
        completion?(nil)
    }
    
    
}

// MARK: UserDataService+UserDefaults

extension UserDataService {
    
    private var defaults: UserDefaults {
        return UserDefaults.standard
    }
    
    private var encoder: JSONEncoder {
        return JSONEncoder()
    }
    
    private var decoder: JSONDecoder {
        return JSONDecoder()
    }
    
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
