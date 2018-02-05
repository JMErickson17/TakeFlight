//
//  SortOptions.swift
//  TakeFlight
//
//  Created by Justin Erickson on 1/18/18.
//  Copyright © 2018 Justin Erickson. All rights reserved.
//

import Foundation

enum SortOption: RefineOption {
    case price
    case duration
    case takeoffTime
    case landingTime
    
    var description: String {
        switch self {
        case .price: return "Price"
        case .duration: return "Duration"
        case .takeoffTime: return "Takeoff Time"
        case .landingTime: return "Landing Time"
        }
    }
}
