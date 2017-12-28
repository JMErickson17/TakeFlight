//
//  SortFilterOptions.swift
//  TakeFlight
//
//  Created by Justin Erickson on 12/26/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import Foundation

protocol SortFilterOption {}

class SortFilterOptions {
    
    // MARK: Types
    
    enum SortOption: String, SortFilterOption {
        case price = "Price"
        case duration = "Duration"
        case takeoffTime = "Takeoff Time"
        case landingTime = "Landing Time"
    }
    
    enum FilterOption: String, SortFilterOption {
        case airlines = "Airlines"
        case stops = "Stops"
        case duration = "Duration"
    }
    
//    struct FilteredCarrier {
//        let name: String
//        let isIncluded: Bool
//    }
    
    // MARK: Properties
    
    var filterableCarriers: [FilterableCarrier]?
    
    var sortOptions: [SortOption] = [.price, .duration, .takeoffTime, .landingTime]
    var filterOptions: [FilterOption] = [.airlines, .stops, .duration]
    
    var selectedSortOption: SortOption
    var selectedFilterOptions: [FilterOption] = []
    
    //    var filteredCarriers: [FilteredCarrier]?
    
    // MARK: Lifecycle
    
    init(selectedSortOption: SortOption, filterableCarriers: [FilterableCarrier]?) {
        self.selectedSortOption = selectedSortOption
        self.filterableCarriers = filterableCarriers
    }
    
    convenience init() {
        self.init(selectedSortOption: .price, filterableCarriers: nil)
    }
    
    // MARK: Convenience
    
    func setCarriers(to carriers: [String]) {
        var filterableCarriers = [FilterableCarrier]()
        let uniqueCarriers = Array(Set(carriers))
        uniqueCarriers.forEach { carrier in
            filterableCarriers.append(FilterableCarrier(name: carrier, isFiltered: false))
        }
        self.filterableCarriers = filterableCarriers
    }
}
