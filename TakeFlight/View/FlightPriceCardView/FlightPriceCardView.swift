//
//  FlightPriceCardView.swift
//  TakeFlight
//
//  Created by Justin Erickson on 1/26/18.
//  Copyright © 2018 Justin Erickson. All rights reserved.
//

import UIKit

class FlightPriceCardView: UIView {

    // MARK: Properties
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var passengersLabel: UILabel!
    @IBOutlet weak var saleFareLabel: UILabel!
    @IBOutlet weak var saleTaxLabel: UILabel!
    @IBOutlet weak var saleTotalLabel: UILabel!
    
    // MARK: Initialization
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    convenience init() {
        self.init(frame: .zero)
        setupView()
    }
    
    // MARK: Setup
    
    private func setupView() {
        Bundle.main.loadNibNamed("FlightPriceCardView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.layer.cornerRadius = 5
        contentView.clipsToBounds = true
    }
    
    // MARK: Configuration
    
    func configureView(withPassengers passengers: String, saleFare: String?, saleTax: String?, saleTotal: String?) {
        self.passengersLabel.text = passengers
        self.saleFareLabel.text = saleFare
        self.saleTaxLabel.text = saleTax
        self.saleTotalLabel.text = saleTotal
    }
}



