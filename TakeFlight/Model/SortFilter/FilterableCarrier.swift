//
//  FilterableCarrier.swift
//  TakeFlight
//
//  Created by Justin Erickson on 12/27/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import Foundation

struct FilterableCarrier {
    let name: String
    var isFiltered: Bool
}

// MARK: - FilterableCarrier+Equatable

extension FilterableCarrier: Equatable {
    static func ==(lhs: FilterableCarrier, rhs: FilterableCarrier) -> Bool {
        return lhs.name == rhs.name && lhs.isFiltered == rhs.isFiltered
    }
}
