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
    
    // MARK: Properties
    
    public private(set) var airports = [Airport]()

    // Google QPX Express API
    private let GOOGLE_REQUEST_URI = "https://www.googleapis.com/qpxExpress/v1/trips/search?key=AIzaSyDRrFNibpoBA2FELmAAHX_SEj1_yBaUN4E"
    
    // MARK: Convenience
    
/**
     Retreives the list of airports from Firebase Database and stores them in the airports variable.
 */
    func populateAirportData() {
        FirebaseDataService.instance.getAirports { (airports) in
            self.airports = airports
        }
    }
    
/**
     Returns an array of airports containing the search query.
 */
    func searchAirports(forQuery query: String) -> [Airport] {
        return airports.filter { $0.searchRepresentation.lowercased().contains(query.lowercased()) }
    }
    
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
                    flightData = FlightData.parseQPXExpressToAirports(fromData: json)
                }
                completion(flightData)
            }
        }
    }
}
