//
//  CarrierPickerCell.swift
//  TakeFlight
//
//  Created by Justin Erickson on 12/27/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import UIKit

class CarrierPickerCell: UITableViewCell {

    // MARK: Properties
    
    @IBOutlet weak var carrierLabel: UILabel!
    @IBOutlet weak var carrierFilterSwitch: UISwitch!
    
    var carrier: FilterableCarrier?
    weak var delegate: CarrierPickerCellDelegate?
    
    // MARK: Actions
    
    @IBAction func filterCarrierSwitchDidChange(_ sender: Any) {
        carrier?.isFiltered = !carrierFilterSwitch.isOn
        if let carrier = carrier {
            delegate?.carrierPickerCell(self, didUpdateCarrier: carrier)
        }
    }

    // MARK: Convenience
    
    func configureCell(withFilterableCarrier carrier: FilterableCarrier) {
        self.carrier = carrier
        carrierLabel.text = carrier.name
        carrierFilterSwitch.isOn = !carrier.isFiltered
    }
}
