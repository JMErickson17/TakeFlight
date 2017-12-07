//
//  FlightDataCell.swift
//  TakeFlight
//
//  Created by Justin Erickson on 12/4/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import UIKit

class FlightDataCell: UITableViewCell {
    
    func makePriceString(withPrice price: Double) -> String {
        let price = price as NSNumber
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter.string(from: price) ?? ""
    }
    
    func makeTimeString(departureTime: DateAndTimeZone, arrivalTime: DateAndTimeZone) -> NSAttributedString {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        
        let departureString = departureTime.toLocalDateAndTimeString(withFormatter: formatter)
        let arrivalString = arrivalTime.toLocalDateAndTimeString(withFormatter: formatter)
        
        return NSAttributedString(string: "\(departureString)-\(arrivalString)")
    }
    
    func makeDurationString(withDuration duration: Int) -> String {
        let hours = duration / 60
        let minutes = duration % 60
        return "\(hours)h \(minutes)m"
    }
    
    func makeStopCountString(with stops: Int) -> String {
        if stops == 0 {
            return "Non-Stop"
        } else {
            return "\(stops) \((stops == 1 ? "stop" : "stops"))"
        }
    }

}
