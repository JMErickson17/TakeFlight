//
//  MyFlightCell.swift
//  TakeFlight
//
//  Created by Justin Erickson on 1/1/18.
//  Copyright © 2018 Justin Erickson. All rights reserved.
//

import UIKit

class MyFlightCell: UITableViewCell {
    
    // MARK: Properties
    
    @IBOutlet weak var myFlightCardView: MyFlightCardView!
    
    private var flightData: FlightData?
    
    // MARK: Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupView()
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        myFlightCardView.containingCell(isSelected: highlighted)
    }
    
    // MARK: Setup

    private func setupView() {
        selectionStyle = .none
    }
    
    // MARK: Convenience
    
    func configureCell(with flightData: FlightData) {
        self.flightData = flightData
        myFlightCardView.configureCard(with: flightData)
    }
}
