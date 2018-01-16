//
//  FirebaseDataService.swift
//  TakeFlight
//
//  Created by Justin Erickson on 10/15/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import Foundation
import Firebase

final class FirestoreDataService {
    
    enum FirebaseFirestoreError: Error {
        case documentDoesntExist
    }
    
    static let instance = FirestoreDataService()
    private init() {
        getCarriers { carriers, error in
            if let error = error { return print("Could not load inital carriers: \(error.localizedDescription)") }
            if let carriers = carriers {
                self.carriers = carriers
            }
        }
        
        getTempAirports { (airports, error) in
            if let error = error { return print("Could not load inital airports: \(error.localizedDescription)") }
            if let airports = airports {
                self.airports = airports
            }
        }
        
    }
    
    // MARK: Properties
    
    var carriers = [Carrier]()
    var airports = [Airport]()
    
    private var database: Firestore {
        return Firestore.firestore()
    }
    
    private var carrierCollectionRef: CollectionReference {
        return database.collection("airlines")
    }
    
    private var airportsCollectionRef: CollectionReference {
        return database.collection("airports")
    }
    
/*
     Temporary airports returned from QPXExpress responses
     These airports are being stored in the firestore database as confirmed airports and should be mapped
     to TakeFlight.Airport at a later date
 */
    
    struct Airport {
        var name: String
        var code: String
        var city: String
        
        var dictionaryRepresentation: [String: Any] {
            return [
                "name": name,
                "code": code,
                "city": city
            ]
        }
        
        init(name: String, code: String, city: String) {
            self.name = name
            self.code = code
            self.city = city
        }
        
        init?(data: JSONRepresentable) {
            guard let name = data["name"] as? String else { return nil }
            guard let code = data["code"] as? String else { return nil }
            guard let city = data["city"] as? String else { return nil }
            self.init(name: name, code: code, city: city)
        }
    }
    
    // MARK: Old Database
    
    let REF_BASE = Constants.DB_BASE
    let REF_AIRPORTS = Constants.DB_BASE.child("airports")

    func getAirports(completion: @escaping ([TakeFlight.Airport]) -> Void) {
        var airports = [TakeFlight.Airport]()
        
        DispatchQueue.global(qos: .default).async {
            self.REF_AIRPORTS.observeSingleEvent(of: .value, with: { (snapshot) in
                if let snapshot = snapshot.value as? [[String: Any]] {
                    for snap in snapshot {
                        if let airport = TakeFlight.Airport(airportDictionary: snap) {
                            airports.append(airport)
                        }
                    }
                }
                completion(airports)
            })
        }
    }
}

// MARK: CarrierService

extension FirestoreDataService: CarrierService {
    
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

// MARK: AirportService

extension FirestoreDataService: AirportService {
    
    func create(airport: FirestoreDataService.Airport, completion: ErrorCompletionHandler?) {
        airportsCollectionRef.document(airport.code).setData(airport.dictionaryRepresentation, completion: completion)
    }
    
    func get(airportWithCode code: String, completion: @escaping (FirestoreDataService.Airport?, Error?) -> Void) {
        airportsCollectionRef.document(code).getDocument { document, error in
            if let error = error { return completion(nil, error) }
            if let document = document {
                guard document.exists else { return completion(nil, FirebaseFirestoreError.documentDoesntExist) }
                let data = document.data()
                if let airport = Airport(data: data) {
                    completion(airport, nil)
                }
            }
        }
    }
    
    func getTempAirports(completion: @escaping ([FirestoreDataService.Airport]?, Error?) -> Void) {
        var airports = [Airport]()
        airportsCollectionRef.getDocuments { documentSnapshot, error in
            if let error = error { return completion(nil, error) }
            if let documents = documentSnapshot?.documents {
                for document in documents {
                    let data = document.data()
                    if let airport = Airport(data: data) {
                        airports.append(airport)
                    }
                }
                completion(airports, nil)
            }
        }
    }
    
    func handleNewAirports(newAirports: [QPXExpress.Response.Airport]) {
        for airport in newAirports {
            if !airports.contains(where: { $0.code == airport.code }) {
                let newAirport = Airport(name: airport.name, code: airport.code, city: airport.city)
                create(airport: newAirport, completion: { error in
                    if let error = error { return print("Error saving airline: \(error.localizedDescription)")}
                    self.airports.append(newAirport)
                })
            }
        }
    }
}
