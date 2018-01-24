//
//  MyFlightCardView.swift
//  TakeFlight
//
//  Created by Justin Erickson on 1/23/18.
//  Copyright © 2018 Justin Erickson. All rights reserved.
//

import UIKit

class MyFlightCardView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var longDescriptionLabel: UILabel!
    @IBOutlet weak var originLabel: UILabel!
    @IBOutlet weak var destinationLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupView()
    }
    
    private func setupView() {
        Bundle.main.loadNibNamed("MyFlightCardView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.layer.cornerRadius = 5
        contentView.clipsToBounds = true
    }
    
    func configureCard(with flightData: FlightData) {
        self.longDescriptionLabel.text = flightData.longDescription
        self.originLabel.text = flightData.departingFlight.originAirportCode
        self.destinationLabel.text = flightData.departingFlight.destinationAirportCode
    }

}
