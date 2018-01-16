//
//  FilterOptions.swift
//  TakeFlight
//
//  Created by Justin Erickson on 12/28/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import Foundation



struct FilterOptions {
    
    // MARK: Types
 
    enum Option: String, SortFilterOption {
        case airlines = "Airlines"
        case stops = "Stops"
        case duration = "Duration"
    }
    
    // MARK: Properties
    
    private(set) var filteredCarriers: [FilterableCarrier]?
    private(set) var maxStops: MaxStops?
    private(set) var maxDuration: Hour?
    
    var hasActiveFilters: Bool {
        return (activeCarrierFilters.count > 0) ||
                maxStops != nil ||
                maxDuration != nil
    }
    
    var activeCarrierFilters: [FilterableCarrier] {
        return filteredCarriers?.filter { $0.isFiltered == true } ?? [FilterableCarrier]()
    }
    
    init() {
        self.filteredCarriers = FirestoreDataService.instance.carriers.map { carrier in
            return FilterableCarrier(carrier: carrier, isFiltered: false)
        }
    }
    
    // MARK: Convenience
    
    mutating func update(_ filterableCarrier: FilterableCarrier) {
        if let index = filteredCarriers?.index(where: { $0.carrier.name == filterableCarrier.carrier.name}) {
            filteredCarriers?[index].isFiltered = filterableCarrier.isFiltered
        }
    }
    
    mutating func update(_ maxStops: MaxStops) {
        self.maxStops = maxStops
    }
    
    mutating func update(_ maxDuration: Hour) {
        self.maxDuration = maxDuration
    }
    
    mutating func resetFilters() {
        maxStops = nil
        maxDuration = nil
        self.filteredCarriers = FirestoreDataService.instance.carriers.map { carrier in
            return FilterableCarrier(carrier: carrier, isFiltered: false)
        }
    }
}
