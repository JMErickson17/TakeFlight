//
//  FlightDataCell.swift
//  TakeFlight
//
//  Created by Justin Erickson on 11/4/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import UIKit

class OneWayFlightDataCell: UITableViewCell {
    
    // MARK: Properties
    
    @IBOutlet weak var airlineImage: UIImageView!
    @IBOutlet weak var takeOffTimeLabel: UILabel!
    @IBOutlet weak var landingTimeLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var stopCountLabel: UILabel!
    @IBOutlet weak var flightTimeLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var priceSourceLabel: UILabel!


    func configureCell(withFlightData data: FlightData) {
        takeOffTimeLabel.text = data.departureTime.toTime()
        landingTimeLabel.text = data.arrivalTime.toTime()
        detailsLabel.text = "\(data.tripDetails) \(data.carrier)"
        stopCountLabel.text = "\(data.numberOfStops) \(data.numberOfStops == 1 ? "stop" : "stops")"
        flightTimeLabel.text = data.duration
        priceLabel.text = data.saleTotal
        priceSourceLabel.text = "Via \(data.carrier)"
    }
    
}
