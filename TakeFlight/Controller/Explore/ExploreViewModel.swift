//
//  ExploreViewModel.swift
//  TakeFlight
//
//  Created by Justin Erickson on 1/30/18.
//  Copyright © 2018 Justin Erickson. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct ExploreViewModel {
    
    // MARK: Properties
    
    private(set) var popularDestinations = [Destination]()
    
    private let destinationService: DestinationService!
    
    init(destinationService: DestinationService) {
        self.destinationService = destinationService
        popularDestinations = destinations
    }
    
    private let destinations = [
        Destination(city: "New York", state: "New York", country: "US", airports: ["JFK"]),
        Destination(city: "Miami", state: "Florida", country: "US", airports: ["MIA"]),
        Destination(city: "Las Vegas", state: "Nevada", country: "US", airports: ["LAS"]),
        Destination(city: "Atlanta", state: "Georgia", country: "US", airports: ["ATL"]),
        Destination(city: "Boston", state: "Massachusetts", country: "US", airports: ["BOS"]),
        Destination(city: "Los Angeles", state: "California", country: "US", airports: ["LAX"]),
        Destination(city: "Fort Lauderdale", state: "Florida", country: "US", airports: ["FLL"]),
        Destination(city: "San Fransico", state: "California", country: "US", airports: ["SFO"]),
        Destination(city: "Tampa", state: "Florida", country: "US", airports: ["TPA"]),
        Destination(city: "Washington DC", state: "The District of Columbia", country: "US", airports: ["DCA"]),
        Destination(city: "Seattle", state: "Washington", country: "US", airports: ["SEA"])
    ]
}
