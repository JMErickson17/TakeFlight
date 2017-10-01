//
//  DataService.swift
//  TakeFlight
//
//  Created by Justin Erickson on 10/1/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import Foundation
import Alamofire

final class DataService {
    
    static let instance = DataService()
    private init() {}
    
    // MARK: Properties
    
    // Laminar API
    private let LAMINAR_BASE_URL = "https://api.laminardata.aero/v1/"
    private let LAMINAR_API_KEY = "e6e8e6e5695eb8405ee3a66f1a86d060"

    // Google QPX Express API
    private let GOOGLE_REQUEST_URI = "https://www.googleapis.com/qpxExpress/v1/trips/search?key=AIzaSyDRrFNibpoBA2FELmAAHX_SEj1_yBaUN4E"
    
    // MARK: Convenience
    
    func retrieveFlightData() {
        
    }
 
}
