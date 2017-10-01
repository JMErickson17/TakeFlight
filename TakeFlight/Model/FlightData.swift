//
//  FlightData.swift
//  TakeFlight
//
//  Created by Justin Erickson on 10/1/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import UIKit

struct FlightData {
    
    // MARK: Properties
    
    public private(set) var airlineName: String!
    public private(set) var airlineIcon: UIImage!
    public private(set) var departureTime: Date!
    public private(set) var arrivalTime: Date!
    public private(set) var numberOfStops: Int!
    public private(set) var flightTime: Double!
    public private(set) var price: Double!
    
    // MARK: Lifetime
    
    init(airlineName: String, airlineIcon: UIImage, departureTime: Date, arrivalTime: Date, numberOfStops: Int, flightTime: Double, price: Double) {
        self.airlineName = airlineName
        self.airlineIcon = airlineIcon
        self.departureTime = departureTime
        self.arrivalTime = arrivalTime
        self.numberOfStops = numberOfStops
        self.flightTime = flightTime
        self.price = price
    }
}
