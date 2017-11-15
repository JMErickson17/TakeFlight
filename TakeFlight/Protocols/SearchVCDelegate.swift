//
//  FlightConvertable.swift
//  TakeFlight
//
//  Created by Justin Erickson on 10/22/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import Foundation

protocol SearchVCDelegate: class {
    var datesSelected: SelectedState { get }
    var selectedSearchType: SearchType { get set }
    var origin: Airport? { get set }
    var destination: Airport? { get set }
    var departureDate: Date? { get set }
    var returnDate: Date? { get set }
    
    func searchVC(_ searchVC: SearchVC, shouldClearLocations: Bool)
    func searchVC(_ searchVC: SearchVC, shouldClearDates: Bool)
    func searchVC(_ searchVC: SearchVC, shouldDismissAirportPicker: Bool)
    func searchVC(_ searchVC: SearchVC, shouldDismissDatePicker: Bool)
}
