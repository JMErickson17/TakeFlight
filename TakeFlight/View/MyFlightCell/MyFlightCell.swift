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
    
    private lazy var noFlightsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.text = "You don't have any upcoming flights.\nFind your next flight using the search tab."
        return label
    }()
    
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
        
        addSubview(noFlightsLabel)
        NSLayoutConstraint.activate([
            noFlightsLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            noFlightsLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    // MARK: Convenience
    
    func configureCell(with flightData: FlightData) {
        noFlightsLabel.isHidden = true
        self.flightData = flightData
        myFlightCardView.configureCard(with: flightData)
    }
}
