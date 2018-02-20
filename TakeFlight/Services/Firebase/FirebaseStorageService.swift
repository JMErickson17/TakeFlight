//
//  FirebaseStorageService.swift
//  TakeFlight
//
//  Created by Justin Erickson on 12/29/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import Foundation
import Firebase

struct FirebaseStorageService {
    
    // MARK: Properties
    
    private var storage: Storage
    
    private var storageRef: StorageReference {
        return storage.reference()
    }
    
    init(storage: Storage) {
        self.storage = storage
    }
}

// MARK:- UserStorageService

extension FirebaseStorageService: UserStorageService {
    
    private var profileImagesRef: StorageReference {
        return storageRef.child("profileImages")
    }
    
    func upload(userProfileImage imageData: Data, forUser user: User, completion: ((URL?, Error?) -> Void)?) {
        DispatchQueue.global().async {
            let imagePath = self.profileImagesRef.child(user.uid)
            imagePath.putData(imageData, metadata: nil) { metaData, error in
                if let error = error, let completion = completion { return completion(nil, error) }
                if let metaData = metaData, let completion = completion {
                    return completion(metaData.downloadURL(), nil)
                }
            }
        }
    }
    
    func download(userProfileImageWithUID uid: String, completion: @escaping (Data?, Error?) -> Void) {
        DispatchQueue.global().async {
            let imagePath = self.profileImagesRef.child(uid)
            imagePath.getData(maxSize: 1 * 1024 * 1024, completion: completion)
        }
    }
    
    func delete(userProfileImageWithUID uid: String, completion: ErrorCompletionHandler?) {
        DispatchQueue.global().async {
            let imagePath = self.profileImagesRef.child(uid)
            imagePath.delete(completion: completion)
        }
    }
}

// MARK: DestinationStorageService

protocol DestinationStorageService {
    func upload(imageData: Data, for destination: Destination, completion: @escaping (URL?, Error?) -> Void)
    func download(imageForDestination destination: Destination, completion: @escaping (Data?, Error?) -> Void)
}

extension FirebaseStorageService: DestinationStorageService {
    
    private var destinationCellImagesRef: StorageReference {
        return storageRef.child("destinationCellImages")
    }
    
    private var destinationImagesRef: StorageReference {
        return storageRef.child("DestinationImages")
    }
    
    func upload(imageData: Data, for destination: Destination, completion: @escaping (URL?, Error?) -> Void) {
        DispatchQueue.global().async {
            let imagePath = self.destinationCellImagesRef.child(destination.city)
            imagePath.putData(imageData, metadata: nil) { metaData, error in
                if let error = error { return completion(nil, error) }
                if let metaData = metaData {
                    completion(metaData.downloadURL(), nil)
                }
            }
        }
    }
    
    func download(imageForDestination destination: Destination, completion: @escaping (Data?, Error?) -> Void) {
        DispatchQueue.global().async {
            let imagePath = self.destinationImagesRef.child("\(destination.city).png")
            imagePath.getData(maxSize: 2 * 1024 * 1024, completion: completion)
        }
    }
}
