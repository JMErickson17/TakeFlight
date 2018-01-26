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
    @IBOutlet weak var baseFareLabel: UILabel!
    @IBOutlet weak var saleFareLabel: UILabel!
    @IBOutlet weak var saleTaxLabel: UILabel!
    @IBOutlet weak var saleTotalLabel: UILabel!
    
    // MARK: Lifecycle
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
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
    
    func configureView(withBaseFare baseFare: String?, saleFare: String?, saleTax: String?, saleTotal: String?) {
        self.baseFareLabel.text = baseFare
        self.saleFareLabel.text = saleFare
        self.saleTaxLabel.text = saleTax
        self.saleTotalLabel.text = saleTotal
    }
}
