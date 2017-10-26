//
//  FlightConvertable.swift
//  TakeFlight
//
//  Created by Justin Erickson on 10/22/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import Foundation

protocol FlightConvertable {
    var origin: String? { get set }
    var destination: String? { get set }
    var departureDate: Date? { get set }
    var returnDate: Date? { get set }
    var datesSelected: SelectedState { get set }
}
