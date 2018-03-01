//
//  DestinationDetailsService.swift
//  TakeFlight
//
//  Created by Justin Erickson on 2/28/18.
//  Copyright © 2018 Justin Erickson. All rights reserved.
//

import Foundation

protocol DestinationDetailsService {
    func details(forGeoname geoname: String, completion: @escaping (DestinationDetails?, Error?) -> ())
}
