//
//  AirportService.swift
//  TakeFlight
//
//  Created by Justin Erickson on 1/16/18.
//  Copyright © 2018 Justin Erickson. All rights reserved.
//

import Foundation

protocol AirportService {
    func create(airport: FirestoreDataService.Airport, completion: ErrorCompletionHandler?)
    func get(airportWithCode code: String, completion: @escaping (FirestoreDataService.Airport?, Error?) -> Void)
}
