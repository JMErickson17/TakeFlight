//
//  FlightConvertable.swift
//  TakeFlight
//
//  Created by Justin Erickson on 10/22/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import UIKit

protocol SearchVCDelegate: class {
    var datesSelected: SelectedState { get }
    var selectedSearchType: SearchType { get set }
    var origin: Airport? { get set }
    var destination: Airport? { get set }
    var departureDate: Date? { get set }
    var returnDate: Date? { get set }
    
    func searchVC(_ searchVC: SearchVC, clearLocations: Bool)
    func searchVC(_ searchVC: SearchVC, clearDates: Bool)
    func searchVC(_ searchVC: SearchVC, dismissAirportPicker: Bool)
    func searchVC(_ searchVC: SearchVC, dismissDatePicker: Bool)
}
