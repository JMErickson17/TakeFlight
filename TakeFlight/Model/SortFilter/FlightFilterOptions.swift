//
//  FlightFilterOptions.swift
//  TakeFlight
//
//  Created by Justin Erickson on 1/18/18.
//  Copyright © 2018 Justin Erickson. All rights reserved.
//

import Foundation

enum FilterOption: SortFilterOption {
    case airlines
    case stops
    case duration
    
    var description: String {
        switch self {
        case .airlines: return "Airlines"
        case .stops: return "Stops"
        case .duration: return "Duration"
        }
    }
}

struct FlightFilterOptions {
    var filteredCarriers: [Carrier]
    var maxStops: MaxStops
    var maxDuration: Hour
    
    init() {
        self.filteredCarriers = [Carrier]()
        self.maxStops = MaxStops.six
        self.maxDuration = 40
    }
    
    mutating func resetFilters() {
        filteredCarriers.removeAll()
        maxStops = .six
        maxDuration = 40
    }
}
