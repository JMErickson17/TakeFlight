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
    
    // Laminar API
    private let LAMINAR_BASE_URL = "https://api.laminardata.aero/v1/"
    private let LAMINAR_API_KEY = "e6e8e6e5695eb8405ee3a66f1a86d060"

    // Google QPX Express API
    private let GOOGLE_REQUEST_URI = "https://www.googleapis.com/qpxExpress/v1/trips/search?key=AIzaSyDRrFNibpoBA2FELmAAHX_SEj1_yBaUN4E"
    
    // MARK: Convenience
    
/**
     Performs a given request to the QPXExpress server and passes the response data to the completion handler.
     
     - Parameter forRequest: A QPXExpress object containing the request for flight information.
     - Parameter completion: A completion handler that is passed a data object returned from the server or nil.
 */
    func retrieveFlightData(forRequest request: QPXExpress, completion: @escaping (Data?) -> Void) {
        let headers = ["Content-Type": "application/json"]
        let requestDict = request.dictionaryRepresentation

        Alamofire.request(GOOGLE_REQUEST_URI, method: .post, parameters: requestDict, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in

            guard response.error == nil else { completion(nil); return }
            
            completion(response.data)
        }
    }
}
