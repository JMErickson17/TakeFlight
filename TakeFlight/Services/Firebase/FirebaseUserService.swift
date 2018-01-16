//
//  FirebaseUserService.swift
//  TakeFlight
//
//  Created by Justin Erickson on 1/16/18.
//  Copyright © 2018 Justin Erickson. All rights reserved.
//

import Foundation
import Firebase

class FirebaseUserService: UserService {
    
    // MARK: Properties
    
    var currentUser: User? {
        didSet {
            if currentUser != nil && userDidUpdateListener == nil {
                addUserDidUpdateListener()
            } else if currentUser == nil && userDidUpdateListener != nil {
                removeUserDidUpdateListener()
            }
        }
    }

    private let database: Firestore
    
    private var usersCollectionRef: CollectionReference {
        return database.collection("users")
    }
    
    private var currentUserRef: DocumentReference? {
        if let currentUser = currentUser {
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
    
    // MARK: Lifecycle
    
    init(database: Firestore) {
        self.database = database
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
            if let imageData = UIImageJPEGRepresentation(image, UIImage.JPEGQuality.highest.rawValue), let currentUser = self.currentUser {
                FirebaseStorageService.instance.upload(userProfileImage: imageData, forUser: currentUser, completion: { url, error in
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
    
    func saveToCurrentUser(userSearchRequest request: UserSearchRequest, completion: ErrorCompletionHandler?) {
        DispatchQueue.global().async {
            if let currentUserSearchHistoryCollectionRef = self.currentUserSearchHistoryCollectionRef {
                currentUserSearchHistoryCollectionRef.addDocument(data: request.dictionaryRepresentation, completion: { (error) in
                    if let error = error, let completion = completion { return completion(error) }
                    DispatchQueue.main.async {
                        // NotificationCenter.default.post(name: .userPropertiesDidChange, object: nil)
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
    
    // MARK: Convenience
    
    private func saveUserToDatabase(_ user: User, completion: ErrorCompletionHandler?) {
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
    
    // Temp Listeners
    // TODO: Convert to reactive
    
    private var handleAuthStateDidChange: AuthStateDidChangeListenerHandle?
    private var userDidUpdateListener: ListenerRegistration?
    
    private func addAuthListener() {
        handleAuthStateDidChange = Auth.auth().addStateDidChangeListener({ (auth, firUser) in
            if let firUser = firUser {
                self.getUser(withUID: firUser.uid, completion: { (user, error) in
                    if let _ = error { return /* Log Error */ }
                    if let user = user {
                        self.currentUser = user
                        DispatchQueue.main.async {
                            NotificationCenter.default.post(name: .authStatusDidChange, object: user)
                        }
                    }
                })
            } else {
                DispatchQueue.main.async {
                    self.currentUser = nil
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
                        let documentData = documentSnapshot.data()
                        if let updatedUser = User(data: documentData) {
                            self.currentUser = updatedUser
                            DispatchQueue.main.async {
                                NotificationCenter.default.post(name: .userPropertiesDidChange, object: updatedUser)
                            }
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
