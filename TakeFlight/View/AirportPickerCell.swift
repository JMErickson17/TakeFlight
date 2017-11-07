//
//  AirportPickerCell.swift
//  TakeFlight
//
//  Created by Justin Erickson on 10/27/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import UIKit

class AirportPickerCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    func configureCell(name: String, location: String) {
        self.nameLabel.text = name
        self.locationLabel.text = location
    }
    
}
