//
//  FlightDataCell.swift
//  TakeFlight
//
//  Created by Justin Erickson on 10/1/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import UIKit

class RoundTripFlightDataCell: FlightDataCell {
    
    // MARK: Properties

    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var departingAirlineImage: UIImageView!
    @IBOutlet weak var departingTimeLabel: UILabel!
    @IBOutlet weak var departingAirlineNameLabel: UILabel!
    @IBOutlet weak var departingStopCountLabel: UILabel!
    @IBOutlet weak var departingDurationLabel: UILabel!
    
    @IBOutlet weak var returningAirlineImage: UIImageView!
    @IBOutlet weak var returningTimeLabel: UILabel!
    @IBOutlet weak var returningAirlineNameLabel: UILabel!
    @IBOutlet weak var returningStopCountLabel: UILabel!
    @IBOutlet weak var returningDurationLabel: UILabel!
    
    func configureCell(withFlightData data: FlightData) {
        headerLabel.text = data.departingFlight.segmentDescription
        priceLabel.text = makePriceString(withPrice: data.saleTotal)
        
        departingAirlineImage.image = data.departingFlight.carrierLogo
        departingTimeLabel.attributedText = makeTimeString(departureTime: data.departingFlight.departureTime, arrivalTime: data.departingFlight.arrivalTime)
        departingAirlineNameLabel.text = data.departingFlight.carrier.name
        departingStopCountLabel.attributedText = makeStopCountString(with: data.departingFlight.stopCount)
        departingDurationLabel.text = makeDurationString(withDuration: data.departingFlight.duration)
        
        returningAirlineImage.image = data.returningFlight?.carrierLogo
        returningTimeLabel.attributedText = makeTimeString(departureTime: data.returningFlight!.departureTime, arrivalTime: data.returningFlight!.arrivalTime)
        returningAirlineNameLabel.text = data.returningFlight?.carrier.name
        returningStopCountLabel.attributedText = makeStopCountString(with: data.returningFlight?.stopCount ?? -1)
        returningDurationLabel.text = makeDurationString(withDuration: data.returningFlight?.duration ?? -1)
    }
}
