//
//  FirebaseDestinationService.swift
//  TakeFlight
//
//  Created by Justin Erickson on 1/30/18.
//  Copyright © 2018 Justin Erickson. All rights reserved.
//

import Foundation
import Firebase

class FirebaseDestinationService: DestinationService {
    
    var destinations = [Destination]()
    
    private var destinationImages = [String: UIImage]()
    
    private let database: Firestore
    private let storageService: DestinationStorageService
    
    private var destinationsCollectionRef: CollectionReference {
        return database.collection("destinations")
    }
    
    init(database: Firestore, storageService: DestinationStorageService) {
        self.database = database
        self.storageService = storageService
        getAllDestinations()
    }
    
    // MARK: Convenience
    
    private func getAllDestinations() {
        self.getDestinations { destinations, error in
            if let error = error { return print(error) }
            guard let destinations = destinations else { return print("Could not load destinations") }
            self.destinations = destinations
        }
    }
    
    private func getAllImages() {
        for destination in destinations {
            storageService.download(imageForDestination: destination, completion: { data, error in
                if let error = error { return print(error) }
                guard let data = data else { return print("No Data") }
                if let image = UIImage(data: data) {
                    self.destinationImages[destination.city] = image
                }
            })
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
    
    func image(for destination: Destination, completion: @escaping (UIImage?, Error?) -> Void) {
        self.storageService.download(imageForDestination: destination) { data, error in
            if let error = error { return completion(nil, error) }
            if let data = data, let image = UIImage(data: data) {
                self.destinationImages[destination.city] = image
                completion(image, nil)
            }
        }
    }
}
