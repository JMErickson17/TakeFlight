//
//  FlightData+CustomStringConvertable.swift
//  TakeFlight
//
//  Created by Justin Erickson on 1/29/18.
//  Copyright © 2018 Justin Erickson. All rights reserved.
//

import Foundation

extension FlightData: CustomStringConvertible {
    
    var description: String {
        return """
        ----------------------- Flight Data -----------------------
        Date Created: \(createdTimeStamp)
        Sale Total: \(saleTotal)
        Base Fare Total: \(baseFareTotal)
        Sale Fare Total: \(saleFareTotal)
        Sale Tax Total: \(saleTaxTotal)
        Fare Calculation: \(fareCalculation)
        Latest Ticketing Time: \(latestTicketingTime)
        Refundable: \(String(describing: refundable))
        Tax Country: \(taxCountry)\n
        -------------------- Departing Flight --------------------
        \(departingFlight)\n
        -------------------- Returning Flight --------------------
        \(String(describing: returningFlight))\n
        """
    }
}
