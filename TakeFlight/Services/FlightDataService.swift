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
    
    
    func fetchFlightData(forInstaFlightRequest request: InstaFlightRequest) {
        let headers = ["Authorization": authToken,
                       "Content-Type": "application/x-www-form-urlencoded",
                       "grant_type": "client_credentials"]
        
        let requestURL = makeURL(fromInstaFlightRequest: request)
        print(requestURL)
        Alamofire.request(requestURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            print(response)
        }
    }
    
    private func makeURL(fromInstaFlightRequest request: InstaFlightRequest) -> String {
        var options = ["origin=\(request.origin)",
                       "destination=\(request.destination)",
                       "pointofsalecountry=\(request.pointOfSaleCountry)",
                       "onlineitinerariesonly=\(request.onlineItinerariesOnly)",
                       "limit=\(request.limit)",
                       "sortby=\(request.sortBy)",
                       "order=\(request.order)"]
        
        if let departureDate = request.departureDate {
            options.append("departuredate=\(departureDate)")
        }
        
        if let returnDate = request.returnDate {
            options.append("returndate=\(returnDate)")
        }
        
        if let minFare = request.minFare {
            options.append("minfare=\(minFare)")
        }
        
        if let maxFare = request.maxFare {
            options.append("maxfare=\(maxFare)")
        }
        
        return "\(instaFlightTestingEndpoint)?" + options.joined(separator: "&")
    }
    
    
    
    
    
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
    
    // MARK: QPXExpress
    
    private let GOOGLE_REQUEST_URI = "https://www.googleapis.com/qpxExpress/v1/trips/search?key=AIzaSyDRrFNibpoBA2FELmAAHX_SEj1_yBaUN4E"
    
/**
     Performs a given request to the QPXExpress server and passes an array of FlightData to the completion handler.
     
     - Parameter forRequest: A QPXExpress object containing the request for flight information.
     - Parameter completion: A completion handler that is passed an array of FlightData
 */
    func retrieveFlightData(forRequest request: QPXExpress, completion: @escaping ([FlightData]?) -> Void) {
        let headers = ["Content-Type": "application/json"]
        let requestDict = request.dictionaryRepresentation
        var flightData: [FlightData]?

        DispatchQueue.global().async {
            Alamofire.request(self.GOOGLE_REQUEST_URI, method: .post, parameters: requestDict, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
                guard response.error == nil else { completion(nil); return }
                guard let data = response.data else { completion(nil); return }
                
                if let json = try? JSONSerialization.jsonObject(with: data, options: []) as! [String: Any] {
                    flightData = FlightData.parseQPXExpressToFlightData(fromData: json)
                }
                completion(flightData)
            }
        }
    }
}
