//
//  FirebaseStorageService.swift
//  TakeFlight
//
//  Created by Justin Erickson on 12/29/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import Foundation
import Firebase

final class FirebaseStorageService {
    
    static let instance = FirebaseStorageService()
    private init() {}
    
    // MARK: Properties
    
    private var storage: Storage {
        return Storage.storage()
    }
    
    private var storageRef: StorageReference {
        return storage.reference()
    }
    
    private var profileImagesRef: StorageReference {
        return storageRef.child("profileImages")
    }
    
    // MARK: User Images
    
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
}
