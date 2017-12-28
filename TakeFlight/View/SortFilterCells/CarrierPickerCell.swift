//
//  CarrierPickerCell.swift
//  TakeFlight
//
//  Created by Justin Erickson on 12/27/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import UIKit

class CarrierPickerCell: UITableViewCell {

    @IBOutlet weak var carrierLabel: UILabel!
    @IBOutlet weak var carrierSelectedSwitch: UISwitch!
    
    var filterableCarrier: FilterableCarrier?
    weak var delegate: CarrierPickerCellDelegate?

    func configureCell(withFilterableCarrier carrier: FilterableCarrier) {
        filterableCarrier = carrier
        carrierLabel.text = carrier.name
        carrierSelectedSwitch.isOn = !carrier.isFiltered
    }

    @IBAction func filterCarrierSwitchDidChange(_ sender: Any) {
        if let filterableCarrier = filterableCarrier {
            delegate?.carrierPickerCell(self, didUpdateFilterValueTo: carrierSelectedSwitch.isOn, for: filterableCarrier)
        }
    }
}
