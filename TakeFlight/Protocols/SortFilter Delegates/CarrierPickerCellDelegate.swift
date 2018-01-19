//
//  CarrierFilterVCDelegate.swift
//  TakeFlight
//
//  Created by Justin Erickson on 12/27/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import Foundation

protocol CarrierPickerCellDelegate: class {
    func carrierPickerCell(_ carrierPickerCell: CarrierPickerCell, didUpdateCarrierData carrierData: CarrierData)
}
