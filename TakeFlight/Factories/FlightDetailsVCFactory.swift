//
//  FlightDetailsVCFactory.swift
//  TakeFlight
//
//  Created by Justin Erickson on 1/23/18.
//  Copyright © 2018 Justin Erickson. All rights reserved.
//

import Foundation

struct FlightDetailsVCFactory {
    static func makeFlightDetailsVC(with flightData: FlightData) -> FlightDetailsVC {
        let detailsVC = FlightDetailsVC()
        detailsVC.flightData = flightData
        return detailsVC
    }
}
