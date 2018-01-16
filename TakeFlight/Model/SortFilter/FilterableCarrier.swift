//
//  FilterableCarrier.swift
//  TakeFlight
//
//  Created by Justin Erickson on 1/6/18.
//  Copyright © 2018 Justin Erickson. All rights reserved.
//

import Foundation

struct FilterableCarrier {
    let carrier: Carrier
    var isFiltered: Bool
}

extension FilterableCarrier {
    
    init(carrier: Carrier) {
        self.carrier = carrier
        self.isFiltered = false
    }
}
