//
//  FlightDataCell.swift
//  TakeFlight
//
//  Created by Justin Erickson on 11/4/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import UIKit

class OneWayFlightDataCell: FlightDataCell {
    
    // MARK: Properties
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var airlineImage: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var airlineNameLabel: UILabel!
    @IBOutlet weak var stopCountLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!

    func configureCell(withFlightData data: FlightData) {
        headerLabel.text = data.departingFlight.segmentDescription
        priceLabel.text = makePriceString(withPrice: data.saleTotal)
        airlineImage.image = data.departingFlight.carrierLogo
        timeLabel.attributedText = makeTimeString(departureTime: data.departingFlight.departureTime, arrivalTime: data.departingFlight.arrivalTime)
        airlineNameLabel.text = data.departingFlight.carrier.name
        stopCountLabel.attributedText = makeStopCountString(with: data.departingFlight.stopCount)
        durationLabel.text = makeDurationString(withDuration: data.departingFlight.duration)
    }
}

