//
//  SortOptions.swift
//  TakeFlight
//
//  Created by Justin Erickson on 12/28/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import Foundation

struct SortOptions {
    
    enum Option: String, SortFilterOption {
        case price = "Price"
        case duration = "Duration"
        case takeoffTime = "Takeoff Time"
        case landingTime = "Landing Time"
    }
    
    private(set) var selectedSortOption: Option = .price
    
    mutating func setSelectedSortOption(to option: Option) {
        self.selectedSortOption = option
    }
}
