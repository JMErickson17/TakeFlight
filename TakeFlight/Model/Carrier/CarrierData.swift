//
//  CarrierData.swift
//  TakeFlight
//
//  Created by Justin Erickson on 1/23/18.
//  Copyright © 2018 Justin Erickson. All rights reserved.
//

import Foundation

typealias OldCarrierData = (carrier: Carrier, isInCurrentSearch: Bool, isFiltered: Bool)

struct CarrierData {
    let carrier: Carrier
    var isInCurrentSearch: Bool
    var isFiltered: Bool
}
