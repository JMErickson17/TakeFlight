//
//  String+Date.swift
//  TakeFlight
//
//  Created by Justin Erickson on 10/30/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import Foundation

extension String {
    
    func qpxExpressStringToDate() -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mmZZZZZ"
        if let date = formatter.date(from: self) {
            return date
        }
        return nil
    }
}
