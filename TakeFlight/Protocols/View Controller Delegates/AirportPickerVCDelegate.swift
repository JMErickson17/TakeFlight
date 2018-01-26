//
//  Searchable.swift
//  TakeFlight
//
//  Created by Justin Erickson on 10/27/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import Foundation

protocol AirportPickerVCDelegate: class {
    func airportPickerVC(_ airportPickerVC: AirportPickerVC, didPickOriginAirport airport: Airport)
    func airportPickerVC(_ airportPickerVC: AirportPickerVC, didPickDestinationAirport airport: Airport)
    func airportPickerVCDismiss(_ airportPickerVC: AirportPickerVC)
}
