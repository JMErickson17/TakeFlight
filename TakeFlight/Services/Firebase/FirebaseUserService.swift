//
//  FirebaseUserService.swift
//  TakeFlight
//
//  Created by Justin Erickson on 1/16/18.
//  Copyright © 2018 Justin Erickson. All rights reserved.
//

import Foundation
import Firebase
import RxSwift
import RxCocoa

class FirebaseUserService: UserService {
    
    // MARK: Properties
    
    var currentUser = Variable<User?>(nil)
    var profileImage = Variable<UIImage>(#imageLiteral(resourceName: "DefaultProfileImage"))
    var savedFlights = Variable<[FlightData]>([])
    
    private var _currentUser: User? {
        didSet {
            currentUser.value = _currentUser
            setProfileImage()
            setSavedFlights()
            print("Current User Set")
        }
    }
    
    private var _profileImage: UIImage = #imageLiteral(resourceName: "DefaultProfileImage") {
        didSet {
            profileImage.value = _profileImage
        }
    }
    
    private var _savedFlights: [FlightData] = [] {
        didSet {
            savedFlights.value = _savedFlights
        }
    }

    private let database: Firestore
    private let userStorage: UserStorageService
    
    private var usersCollectionRef: CollectionReference {
        return database.collection("users")
    }
    
    private var currentUserRef: DocumentReference? {
        if let currentUser = _currentUser {
            return usersCollectionRef.document(currentUser.uid)
        }
        return nil
    }
    
    private var currentUserSearchHistoryCollectionRef: CollectionReference? {
        if let currentUserRef = currentUserRef {
            return currentUserRef.collection("searchRequests")
        }
        return nil
    }
    
    private var currentUserSavedFlightsCollectionRef: CollectionReference? {
        if let currentUserRef = currentUserRef {
            return currentUserRef.collection("savedFlights")
        }
        return nil
    }
    
    // MARK: Lifecycle
    
    init(database: Firestore, userStorage: UserStorageService) {
        self.database = database
        self.userStorage = userStorage
        addAuthListener()
    }
    
    // MARK: Authentication
    
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
    
    func signOutCurrentUser(completion: ErrorCompletionHandler? = nil) {
        do {
            try Auth.auth().signOut()
            self._currentUser = nil
            completion?(nil)
        } catch {
            completion?(error)
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
    
    func saveToCurrentUser(updatedProperties: [UpdatableUserProperties: Any], completion: ErrorCompletionHandler?) {
        DispatchQueue.global().async {
            var propertiesDictionary = [String: Any]()
            for (key, value) in updatedProperties {
                propertiesDictionary[key.rawValue] = value
            }
            
            if let currentUserRef = self.currentUserRef {
                currentUserRef.setData(propertiesDictionary, options: SetOptions.merge(), completion: { error in
                    DispatchQueue.main.async {
                        if let completion = completion {
                            if let error = error { return completion(error) }
                            completion(nil)
                        }
                    }
                })
            }
        }
    }
    
    func saveToCurrentUser(profileImage image: UIImage, completion: ErrorCompletionHandler?) {
        DispatchQueue.global().async {
            if let imageData = UIImageJPEGRepresentation(image, UIImage.JPEGQuality.highest.rawValue), let currentUser = self._currentUser {
                self.userStorage.upload(userProfileImage: imageData, forUser: currentUser, completion: { url, error in
                    if let error = error, let completion = completion { return completion(error) }
                    if let url = url {
                        let updatedProfileImageURL = [UpdatableUserProperties.profileImageURL: url.absoluteString]
                        self.saveToCurrentUser(updatedProperties: updatedProfileImageURL, completion: { (error) in
                            if let completion = completion {
                                if let error = error { return completion(error) }
                                completion(nil)
                            }
                        })
                    }
                })
            }
        }
    }
    
    func saveToCurrentUser(userSearchRequest request: FlightSearchRequest, completion: ErrorCompletionHandler?) {
        DispatchQueue.global().async {
            if let currentUserSearchHistoryCollectionRef = self.currentUserSearchHistoryCollectionRef {
                currentUserSearchHistoryCollectionRef.addDocument(data: request.dictionaryRepresentation, completion: { (error) in
                    if let error = error, let completion = completion { return completion(error) }
                    DispatchQueue.main.async {
                        completion?(nil)
                    }
                })
            }
        }
    }
    
    func saveToCurrentUser(flightData: FlightData, completion: ErrorCompletionHandler?) {
        DispatchQueue.global(qos: .background).async {
            guard let data = try? JSONEncoder().encode(flightData) else { return /* Throw error */ }
            guard let flightDataDictionary = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)) as? JSONRepresentable else { return /* Throw error */ }
            if let currentUserSavedFlightsCollectionRef = self.currentUserSavedFlightsCollectionRef {
                currentUserSavedFlightsCollectionRef.document(flightData.uid).setData(flightDataDictionary, completion: { error in
                    self.setSavedFlights()
                    DispatchQueue.main.async {
                        completion?(error)
                    }
                })
            }
        }
    }
    
    func getSavedFlightsForCurrentUser(completion: @escaping ([FlightData]?, Error?) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            if let currentUserSavedFlightsCollectionRef = self.currentUserSavedFlightsCollectionRef {
                currentUserSavedFlightsCollectionRef.getDocuments { snapshot, error in
                    if let error = error { return completion(nil, error) }
                    guard let snapshot = snapshot else { return completion(nil, nil) /* Throw error */ }
                    let savedFlights: [FlightData] = snapshot.documents.flatMap { flightData in
                        if let data = try? JSONSerialization.data(withJSONObject: flightData.data(), options: JSONSerialization.WritingOptions.sortedKeys) {
                            return try? JSONDecoder().decode(FlightData.self, from: data)
                        }
                        return nil
                    }
                    DispatchQueue.main.async {
                        completion(savedFlights, nil)
                    }
                }
            }
        }
    }
    
    func delete(savedFlightWithUID uid: String, completion: ErrorCompletionHandler?) {
        DispatchQueue.global().async {
            if let currentUserSavedFlightsCollectionRef = self.currentUserSavedFlightsCollectionRef {
                currentUserSavedFlightsCollectionRef.document(uid).delete(completion: { error in
                    if let error = error, let completion = completion { return completion(error) }
                    if let index = self._savedFlights.index(where: { $0.uid == uid })  {
                        self._savedFlights.remove(at: index)
                    }
                    DispatchQueue.main.async {
                        completion?(nil)
                    }
                })
            }
        }
    }
    
    func clearCurrentUserSearchHistory(completion: ErrorCompletionHandler?) {
        DispatchQueue.global().async {
            if let currentUserSearchHistoryCollectionRef = self.currentUserSearchHistoryCollectionRef {
                currentUserSearchHistoryCollectionRef.limit(to: 100).getDocuments(completion: { (documents, error) in
                    if let error = error, let completion = completion { return completion(error) }
                    if let documents = documents {
                        if documents.isEmpty, let completion = completion { return completion(nil) }
                        
                        let batch = currentUserSearchHistoryCollectionRef.firestore.batch()
                        documents.documents.forEach { batch.deleteDocument($0.reference) }
                        
                        batch.commit(completion: { batchError in
                            if let batchError = batchError, let completion = completion { return completion(batchError) }
                            self.clearCurrentUserSearchHistory(completion: completion)
                        })
                    }
                })
            }
        }
    }
    
    func getProfileImageForCurrentUser(completion: @escaping (UIImage?, Error?) -> Void) {
        DispatchQueue.global().async {
            if let currentUser = self._currentUser {
                self.userStorage.download(userProfileImageWithUID: currentUser.uid, completion: { data, error in
                    if let error = error { return completion(nil, error) }
                    if let imageData = data, let profileImage = UIImage(data: imageData) {
                        completion(profileImage, nil)
                    }
                })
            }
        }
    }
    
    // MARK: Convenience
    
    private func saveUserToDatabase(_ user: User, completion: ErrorCompletionHandler?) {
        usersCollectionRef.document(user.uid).setData(user.dictionaryRepresentation, completion: completion)
    }
    
    private func getUser(withUID uid: String, completion: @escaping (User?, Error?) -> Void) {
        DispatchQueue.global().async {
            self.usersCollectionRef.document(uid).getDocument { (document, error) in
                if let error = error { return completion(nil, error) }
                if let document = document {
                    guard document.exists else { return completion(nil, FirebaseFirestoreError.documentContainsNoData) }
                    guard let data = document.data() else { return completion(nil, FirebaseFirestoreError.documentContainsNoData) }
                    if let user = User(data: data) {
                        completion(user, nil)
                    }
                }
            }
        }
    }
    
    private func setProfileImage() {
        guard let _ = _currentUser else { _profileImage = #imageLiteral(resourceName: "DefaultProfileImage"); return }
        self.getProfileImageForCurrentUser { profileImage, error in
            if let error = error { return print(error) }
            self._profileImage = profileImage ?? #imageLiteral(resourceName: "DefaultProfileImage")
        }
    }
    
    private func setSavedFlights() {
        guard let _ = _currentUser else { _savedFlights.removeAll(); return }
        self.getSavedFlightsForCurrentUser { savedFlights, error in
            if let error = error { return print(error) }
            self._savedFlights = savedFlights ?? []
        }
    }
    
    private func postUserPropertiesDidChange() {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: .userPropertiesDidChange, object: nil)
        }
    }
    
    // MARK: Listeners
    
    private var handleAuthStateDidChange: AuthStateDidChangeListenerHandle?
    private var userDidUpdateListener: ListenerRegistration?
    
    private func addAuthListener() {
        handleAuthStateDidChange = Auth.auth().addStateDidChangeListener({ (auth, firUser) in
            if let firUser = firUser {
                self.getUser(withUID: firUser.uid, completion: { (user, error) in
                    if let _ = error { return /* Log Error */ }
                    if let user = user {
                        if self._currentUser == nil {
                            self._currentUser = user
                            DispatchQueue.main.async {
                                NotificationCenter.default.post(name: .authStatusDidChange, object: user)
                            }
                        }
                        
                    }
                })
            } else {
                DispatchQueue.main.async {
                    self._currentUser = nil
                    NotificationCenter.default.post(name: .authStatusDidChange, object: nil)
                }
            }
        })
    }
    
    private func removeAuthListener() {
        if let handleAuthStateDidChange = handleAuthStateDidChange {
            Auth.auth().removeStateDidChangeListener(handleAuthStateDidChange)
        }
    }
    
    private func addUserDidUpdateListener() {
        DispatchQueue.global().async {
            if let currentUserRef = self.currentUserRef {
                self.userDidUpdateListener = currentUserRef.addSnapshotListener({ (documentSnapshot, error) in
                    if let error = error { print(error) }
                    if let documentSnapshot = documentSnapshot {
                        guard documentSnapshot.exists else { return print("Document does not exist") }
                        guard let documentData = documentSnapshot.data() else { return print("Document contains no data") }
                        if let updatedUser = User(data: documentData) {
                            self._currentUser = updatedUser
                        }
                    }
                })
            }
        }
    }

    private func removeUserDidUpdateListener() {
        userDidUpdateListener?.remove()
    }
}
