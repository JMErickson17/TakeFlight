//
//  DateAndTimeZone.swift
//  TakeFlight
//
//  Created by Justin Erickson on 12/6/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import Foundation

struct DateAndTimeZone {
    var date: Date
    var timeZone: Int
    
    func toLocalDateAndTimeString(withFormatter formatter: DateFormatter) -> String {
        formatter.timeZone = TimeZone(secondsFromGMT: timeZone)
        return formatter.string(from: self.date)
    }
}
