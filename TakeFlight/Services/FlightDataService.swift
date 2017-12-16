//
//  DataService.swift
//  TakeFlight
//
//  Created by Justin Erickson on 10/1/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import Foundation
import Alamofire

final class FlightDataService {
    
    static let instance = FlightDataService()
    private init() {}
    
    // MARK: InstaFlight Search
    
    private let instaFlightsEndpoint = "https://api.havail.sabre.com/v1/shop/flights"
    private let instaFlightTestingEndpoint = "https://api.test.sabre.com/v1/shop/flights"
    
    private let authToken = "Bearer T1RLAQKwW9hVTJ9f86iHXQX+67BRqgWi9RDDxILTEN8nqPDb7iL+NuR8AADAZOCqyLnRFwlrNzntk+WlUJnTt5jFw9VJPCE4SOQ/wHJLC2mDKaFxcYxHhjH0AVNsP28x65DSy+QVXq5KfraixRvUF9HsG4qj5xuxh4MxX7d1tRtehZ7ZDkJ7IJejT10cLiH1eVI8HDNd2/jLJ61kYToGc/6htJ66IatHPAKGzFv31M0dRxzM7V76wU1QbqnZq2F5qoCc6e/0qyvGMt8uAdi29qK2bkabiEUFOZGjPPHdDQXzyXy+68fbezVmlCvh"
    
    let url = "https://api.test.sabre.com/v1/shop/flights?origin=JFK&destination=LAX&departuredate=2018-01-07&returndate=2018-01-08&onlineitinerariesonly=N&limit=10&offset=1&eticketsonly=N&sortby=totalfare&order=asc&sortby2=departuretime&order2=asc&pointofsalecountry=US"
    
    

    
    // MARK: Airports
    
    public private(set) var airports = [Airport]()
    
    func populateAirportData() {
        FirebaseDataService.instance.getAirports { (airports) in
            self.airports = airports
        }
    }
    
    func searchAirports(forQuery query: String) -> [Airport] {
        return airports.filter { $0.searchRepresentation.lowercased().contains(query.lowercased()) }
    }
    
    func airport(forCode code: String) -> Airport? {
        if let index = airports.index(where: { $0.iata == code }) {
            return airports[index]
        }
        return nil
    }
}
