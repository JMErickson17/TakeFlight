//
//  FlightDataCell.swift
//  TakeFlight
//
//  Created by Justin Erickson on 11/4/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import UIKit

class FlightDataCell: UITableViewCell {
    
    // MARK: Properties
    
    @IBOutlet weak var airlineImage: UIImageView!
    @IBOutlet weak var takeOffTimeLabel: UILabel!
    @IBOutlet weak var landingTimeLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var stopCountLabel: UILabel!
    @IBOutlet weak var flightTimeLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var priceSourceLabel: UILabel!

    // MARK: View Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


    func configureCell(withFlightData data: FlightData) {
        
    }
    
}
