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
    
    private(set) var filterableCarriers: [FilterableCarrier]?
    private(set) var maxStops: MaxStops?
    private(set) var maxDuration: Hour?
    
    var hasActiveFilters: Bool {
        return activeCarrierFilters.count > 0 ||
                maxStops != nil ||
                maxDuration != nil
    }
    
    var activeCarrierFilters: [FilterableCarrier] {
        var carriers = [FilterableCarrier]()
        filterableCarriers?.forEach({ carrier in
            if carrier.isFiltered {
                carriers.append(carrier)
            }
        })
        return carriers
    }
    
    // MARK: Convenience
    
    mutating func setupCarriers(with carriers: [String]) {
        var filterableCarriers = [FilterableCarrier]()
        let uniqueCarriers = Array(Set(carriers))
        uniqueCarriers.forEach { carrier in
            filterableCarriers.append(FilterableCarrier(name: carrier, isFiltered: false))
        }
        self.filterableCarriers = filterableCarriers
    }
    
    mutating func setCarriers(to carriers: [FilterableCarrier]) {
        self.filterableCarriers = carriers
    }
    
    mutating func update(_ carrier: FilterableCarrier) {
        if let index = filterableCarriers?.index(where: { $0.name == carrier.name }) {
            filterableCarriers?[index] = carrier
        }
    }
    
    mutating func update(_ maxStops: MaxStops) {
        self.maxStops = maxStops
    }
    
    mutating func update(_ maxDuration: Hour) {
        self.maxDuration = maxDuration
    }
    
    mutating func resetFilters() {
        filterableCarriers = filterableCarriers?.map({ carrier -> FilterableCarrier in
            var carrier = carrier
            carrier.isFiltered = false
            return carrier
        })
        maxStops = nil
        maxDuration = nil
    }
}
