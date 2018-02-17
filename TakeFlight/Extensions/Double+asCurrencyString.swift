//
//  Double+asCurrencyString.swift
//  TakeFlight
//
//  Created by Justin Erickson on 2/16/18.
//  Copyright © 2018 Justin Erickson. All rights reserved.
//

import Foundation

extension Double {
    func asCurrencyString() -> String? {
        let price = self as NSNumber
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter.string(from: price)
    }
}
