//
//  CarrierPriceCell.swift
//  TakeFlight
//
//  Created by Justin Erickson on 2/21/18.
//  Copyright © 2018 Justin Erickson. All rights reserved.
//

import UIKit

class CarrierPriceCell: UITableViewCell {
    
    // MARK: Properties
    
    @IBOutlet weak var carrierImage: UIImageView!
    @IBOutlet weak var carrierLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    private var carrierImages = CarrierImages()
    
    static var nib: UINib? {
        return UINib(nibName: "CarrierPriceCell", bundle: Bundle.main)
    }
    
    func configureCell(with carrier: Carrier, price: Double) {
        self.carrierImage.image = carrierImages[carrier.code]
        self.carrierLabel.text = carrier.name
        self.priceLabel.text = "From $\(Int(price))"
    }
    
}
