//
//  FirebaseAirportService.swift
//  TakeFlight
//
//  Created by Justin Erickson on 1/16/18.
//  Copyright © 2018 Justin Erickson. All rights reserved.
//

import Foundation
import Firebase

class FirebaseAirportService: AirportService {
    
    var airports = [TakeFlight.Airport]()
    var tempAirports = [Airport]()
    
    private let database: Firestore
    
    private var airportsCollectionRef: CollectionReference {
        return database.collection("airports")
    }
    
    init(database: Firestore) {
        self.database = database
        getInitialAirports()
    }
    
    private func getInitialAirports() {
        getTempAirports { (airports, error) in
            if let error = error { return print("Could not load inital airports: \(error.localizedDescription)") }
            if let airports = airports {
                self.tempAirports = airports
            }
        }
    }
    
    func create(airport: FirebaseAirportService.Airport, completion: ErrorCompletionHandler?) {
        airportsCollectionRef.document(airport.code).setData(airport.dictionaryRepresentation, completion: completion)
    }
    
    func get(airportWithCode code: String, completion: @escaping (FirebaseAirportService.Airport?, Error?) -> Void) {
        airportsCollectionRef.document(code).getDocument { document, error in
            if let error = error { return completion(nil, error) }
            if let document = document {
                guard document.exists else { return completion(nil, FirebaseFirestoreError.documentDoesntExist) }
                guard let data = document.data() else { return completion(nil, FirebaseFirestoreError.documentContainsNoData) }
                if let airport = Airport(data: data) {
                    completion(airport, nil)
                }
            }
        }
    }
    
    func getTempAirports(completion: @escaping ([FirebaseAirportService.Airport]?, Error?) -> Void) {
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
            if !tempAirports.contains(where: { $0.code == airport.code }) {
                let newAirport = Airport(name: airport.name, code: airport.code, city: airport.city)
                create(airport: newAirport, completion: { error in
                    if let error = error { return print("Error saving airline: \(error.localizedDescription)")}
                    self.tempAirports.append(newAirport)
                })
            }
        }
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
}
