//
//  AirportService.swift
//  TakeFlight
//
//  Created by Justin Erickson on 1/16/18.
//  Copyright © 2018 Justin Erickson. All rights reserved.
//

import Foundation

protocol AirportService {
    var airports: [Airport] { get }
    
    func getAirports(completion: @escaping ([Airport]?, Error?) -> Void)
    func airport(withIdentifier identifier: String) -> Airport?
    func airports(containing query: String) -> [Airport]
}
