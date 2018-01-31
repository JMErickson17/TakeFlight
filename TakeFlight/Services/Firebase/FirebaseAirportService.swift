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
    
    // MARK: Properties
    
    var airports = [Airport]()
    
    private let database: Firestore
    
    private var airportsCollectionRef: CollectionReference {
        return database.collection("airports")
    }
    
    // MARK: Lifecycle
    
    init(database: Firestore) {
        self.database = database
        getInitialAirports()
    }
    
    // MARK: Convenience
    
    private func getInitialAirports() {
        self.getAirports { airports, error in
            if let error = error { return print(error) }
            guard let airports = airports else { return print("Could not load airports") }
            self.airports = airports
        }
    }
    
    // MARK: Public API
    
    func getAirports(completion: @escaping ([Airport]?, Error?) -> Void) {
        DispatchQueue.global().async {
            self.airportsCollectionRef.getDocuments { snapshot, error in
                if let error = error { return completion(nil, error) }
                let airports: [Airport] = snapshot!.documents.flatMap { airport in
                    if let data = try? JSONSerialization.data(withJSONObject: airport.data(), options: .sortedKeys) {
                        return try? JSONDecoder().decode(Airport.self, from: data)
                    }
                    return nil
                }
                completion(airports, nil)
            }
        }
    }
    
    func create(airport: Airport, completion: @escaping ErrorCompletionHandler) {
        guard let airportData = try? JSONEncoder().encode(airport) else { return completion(FirebaseFirestoreError.couldNotEncodeObject) }
        guard let airportDictionary = (try? JSONSerialization.jsonObject(with: airportData, options: .allowFragments))
            as? JSONRepresentable else { return completion(FirebaseFirestoreError.couldNotEncodeObject) }
        
        airportsCollectionRef.document(airport.iata).setData(airportDictionary, completion: completion)
    }
    
    func airport(withIdentifier identifier: String) -> Airport? {
        if let index = airports.index(where: { $0.iata == identifier}) {
            return airports[index]
        }
        return nil
    }
    
    func airports(containing query: String) -> [Airport] {
        return airports.filter { $0.searchRepresentation.lowercased().contains(query.lowercased()) || $0.locationString.lowercased().contains(query.lowercased()) }
    }
}
