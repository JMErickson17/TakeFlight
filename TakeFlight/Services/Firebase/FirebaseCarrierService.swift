//
//  FirebaseCarrierService.swift
//  TakeFlight
//
//  Created by Justin Erickson on 1/16/18.
//  Copyright © 2018 Justin Erickson. All rights reserved.
//

import Foundation
import Firebase

class FirebaseCarrierService: CarrierService {
    
    // MARK: Properties
    
    var carriers = [Carrier]()
    
    private let database: Firestore
    
    private var carrierCollectionRef: CollectionReference {
        return database.collection("airlines")
    }
    
    // MARK: Lifecycle
    
    init(database: Firestore) {
        self.database = database
        getInitialCarriers()
    }
    
    private func getInitialCarriers() {
        getCarriers { carriers, error in
            if let error = error { return print("Could not load inital carriers: \(error.localizedDescription)") }
            if let carriers = carriers {
                self.carriers = carriers
            }
        }
    }
    
    // MARK: Public API
    
    func create(carrier: Carrier, completion: ErrorCompletionHandler?) {
        carrierCollectionRef.document(carrier.code).setData(carrier.dictionaryRepresentation, completion: completion)
    }
    
    func get(carrierWithCode code: String, completion: @escaping (Carrier?, Error?) -> Void) {
        carrierCollectionRef.document(code).getDocument { document, error in
            if let error = error { return completion(nil, error) }
            if let document = document {
                guard document.exists else { return completion(nil, FirebaseFirestoreError.documentDoesntExist) }
                let data = document.data()
                if let airline = Carrier(documentData: data) {
                    completion(airline, nil)
                }
            }
        }
    }
    
    func getCarriers(completion: @escaping ([Carrier]?, Error?) -> Void) {
        var carriers = [Carrier]()
        carrierCollectionRef.getDocuments { documentSnapshot, error in
            if let error = error { return completion(nil, error) }
            if let documents = documentSnapshot?.documents {
                for document in documents {
                    let data = document.data()
                    if let carrier = Carrier(documentData: data) {
                        carriers.append(carrier)
                    }
                }
                completion(carriers, nil)
            }
        }
    }
    
    
    func handleNewCarriers(newCarriers: [QPXExpress.Response.Carrier]) {
        for carrier in newCarriers {
            if !carriers.contains(where: { $0.code == carrier.code }) {
                let newCarrier = Carrier(name: carrier.name, code: carrier.code)
                create(carrier: newCarrier, completion: { error in
                    if let error = error { return print("Error saving carrier: \(error.localizedDescription)")}
                    self.carriers.append(newCarrier)
                })
            }
        }
    }
}
