//
//  FirebaseDestinationService.swift
//  TakeFlight
//
//  Created by Justin Erickson on 1/30/18.
//  Copyright © 2018 Justin Erickson. All rights reserved.
//

import Foundation
import Firebase

enum FirebaseDestinationError: Error {
    case couldNotCreateImage
}

class FirebaseDestinationService: DestinationService {
    
    // MARK: Properties
    
    var destinations = [Destination]()
    
    private lazy var imageCache: NSCache<NSString, UIImage> = {
        let cache = NSCache<NSString, UIImage>()
        cache.name = "DestinationImageCache"
        cache.countLimit = 40
        cache.totalCostLimit = 40*1024*1024
        return cache
    }()
    
    private let database: Firestore
    private let storageService: DestinationStorageService
    
    private var destinationsCollectionRef: CollectionReference {
        return database.collection("destinations")
    }
    
    // MARK: Lifecycle
    
    init(database: Firestore, storageService: DestinationStorageService) {
        self.database = database
        self.storageService = storageService
        getAllDestinations()
    }
    
    // MARK: Convenience
    
    private func getAllDestinations() {
        DispatchQueue.global().async {
            self.getDestinations { destinations, error in
                if let error = error { return print(error) }
                guard let destinations = destinations else { return print("Could not load destinations") }
                self.destinations = destinations
            }
        }
    }
    
    // MARK: Public API
    
    func getDestinations(completion: @escaping ([Destination]?, Error?) -> Void) {
        DispatchQueue.global().async {
            self.destinationsCollectionRef.getDocuments { snapshot, error in
                if let error = error { return completion(nil, error) }
                let destinations: [Destination] = snapshot!.documents.flatMap { destination in
                    if let data = try? JSONSerialization.data(withJSONObject: destination.data(), options: .sortedKeys) {
                        return try? JSONDecoder().decode(Destination.self, from: data)
                    }
                    return nil
                }
                completion(destinations, nil)
            }
        }
    }
    
    func create(destination: Destination, completion: @escaping ErrorCompletionHandler) {
        guard let destinationData = try? JSONEncoder().encode(destination) else {
            return completion(FirebaseFirestoreError.couldNotEncodeObject)
        }
        guard let destinationDictionary = (try? JSONSerialization.jsonObject(with: destinationData, options: .allowFragments)) as? JSONRepresentable else {
            return completion(FirebaseFirestoreError.couldNotEncodeObject)
        }
        DispatchQueue.global().async {
            self.destinationsCollectionRef.document(destination.city).setData(destinationDictionary, completion: completion)
        }
    }
    
    func create(destination: Destination, with image: UIImage) {
        guard let imageData = UIImagePNGRepresentation(image) else { return print("Could not create data") }
        storageService.upload(imageData: imageData, for: destination) { url, error in
            if let error = error { return print(error) }
            if let url = url {
                let newDestination = Destination(city: destination.city, state: destination.state, country: destination.country, imageURL: url, airports: destination.airports)
                self.create(destination: newDestination, completion: { error in
                    if let error = error { print(error) }
                })
            }
        }
    }
    
    func image(for destination: Destination, completion: @escaping (UIImage?, Error?) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            if let image = self.imageCache.object(forKey: destination.city as NSString) {
                return completion(image, nil)
            }
            
            self.storageService.download(imageForDestination: destination) { data, error in
                if let error = error { return completion(nil, error) }
                if let data = data, let image = UIImage(data: data) {
                    self.imageCache.setObject(image, forKey: destination.city as NSString)
                    DispatchQueue.main.async {
                        return completion(image, nil)
                    }
                }
            }
        }
    }
}
