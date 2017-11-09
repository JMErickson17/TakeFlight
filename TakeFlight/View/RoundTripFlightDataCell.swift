//
//  FlightDataCell.swift
//  TakeFlight
//
//  Created by Justin Erickson on 10/1/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import UIKit

class RoundTripFlightDataCell: UITableViewCell {
    
    // MARK: Properties

    @IBOutlet weak var departingAirlineImage: UIImageView!
    @IBOutlet weak var departingTakeOffTimeLabel: UILabel!
    @IBOutlet weak var departingLandingTimeLabel: UILabel!
    @IBOutlet weak var departingDetailsLabel: UILabel!
    @IBOutlet weak var departingStopCountLabel: UILabel!
    @IBOutlet weak var departingFlightTimeLabel: UILabel!
    
    @IBOutlet weak var returningAirlineImage: UIImageView!
    @IBOutlet weak var returningTakeOffTimeLabel: UILabel!
    @IBOutlet weak var returningLandingTimeLabel: UILabel!
    @IBOutlet weak var returningDetailsLabel: UILabel!
    @IBOutlet weak var returningStopCountLabel: UILabel!
    @IBOutlet weak var returningFlightTimeLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var priceSourceLabel: UILabel!
    
    // MARK: View Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    // MARK: Convenience
    
    
    
/**
     Configure the cell for a given IndexPath
 */
    func configureCell(withFlightDataContainer data: FlightDataContainer) {
        departingTakeOffTimeLabel.text = data.departure.departureTime.toTime()
        departingLandingTimeLabel.text = data.departure.arrivalTime.toTime()
        departingDetailsLabel.text = "\(data.departure.tripDetails) \(data.departure.carrier)"
        departingStopCountLabel.text = "\(data.departure.numberOfStops) \(data.departure.numberOfStops == 1 ? "stop" : "stops")"
        departingFlightTimeLabel.text = data.departure.duration
        priceLabel.text = data.departure.saleTotal
        priceSourceLabel.text = "Via \(data.departure.carrier)"
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
