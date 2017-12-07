//
//  DateRange.swift
//  TakeFlight
//
//  Created by Justin Erickson on 11/2/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import Foundation

struct DateRange {
    
    var startDate: Date
    var endDate: Date
    
    func contains(date: Date) -> Bool {
        return (min(self.startDate, self.endDate)...max(self.startDate, self.endDate)).contains(date)
    }
}
