//
//  Date+ComponentStrings.swift
//  TakeFlight
//
//  Created by Justin Erickson on 10/22/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import Foundation

extension Date {
    
/**
     Converts a date object to a string containing the time.
 */
    func toTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "H:mm"
        let time = formatter.string(from: self)
        return time
    }
    
/**
     Converts a date object to a string containing the month name.
 */
    func toMonth() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        let month = formatter.string(from: self)
        return month
    }
    
/**
     Converts a date object to a string containing the year.
 */
    func toYear() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        let year = formatter.string(from: self)
        return year
    }
    
/**
     Converts a date to a QPXExpress formatted date String.
 */
    func toQPXExpressString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        let dateString = formatter.string(from: self)
        return dateString
    }
}
