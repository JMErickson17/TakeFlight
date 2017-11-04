//
//  FlightConvertable.swift
//  TakeFlight
//
//  Created by Justin Erickson on 10/22/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import Foundation

protocol SearchVCDelegate {
    var datesSelected: SelectedState { get }
    var origin: Airport? { get set }
    var destination: Airport? { get set }
    var departureDate: Date? { get set }
    var returnDate: Date? { get set }
    
    func clearDates()
}
