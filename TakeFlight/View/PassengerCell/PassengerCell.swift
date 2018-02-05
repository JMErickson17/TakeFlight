//
//  PassengerCell.swift
//  TakeFlight
//
//  Created by Justin Erickson on 2/3/18.
//  Copyright © 2018 Justin Erickson. All rights reserved.
//

import UIKit

protocol PassengerCellDelegate: class {
    func passengerCell(_ passengerCell: PassengerCell, didUpdate option: PassengerOption)
}

class PassengerCell: UITableViewCell {

    @IBOutlet weak var adultPicker: PassengerPickerView!
    @IBOutlet weak var childPicker: PassengerPickerView!
    @IBOutlet weak var infantPicker: PassengerPickerView!
    
    weak var delegate: PassengerCellDelegate?
    
    private var adultPassengers: PassengerOption = .adultPassengers(1)
    private var childPassengers: PassengerOption = .childPassengers(0)
    private var infantPassengers: PassengerOption = .infantPassengers(0)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        adultPicker.delegate = adultPicker
        adultPicker.dataSource = adultPicker
        adultPicker.passengerOption = adultPassengers
        adultPicker.passengerDelegate = self
        adultPicker.possibleNumberOfPassengers = Array(1...8)
        
        childPicker.delegate = childPicker
        childPicker.dataSource = childPicker
        childPicker.passengerOption = childPassengers
        childPicker.passengerDelegate = self
        
        infantPicker.delegate = infantPicker
        infantPicker.dataSource = infantPicker
        infantPicker.passengerOption = infantPassengers
        infantPicker.passengerDelegate = self
    }
    
    private func update(_ option: PassengerOption) {
        switch option {
        case .adultPassengers(_):
            self.adultPassengers = option
        case .childPassengers(_):
            self.childPassengers = option
        case .infantPassengers(_):
            self.infantPassengers = option
        }
    }
    
    func configureCell(withAdultCount adultCount: Int, childCount: Int, infantCount: Int) {
        adultPicker.selectRow(adultCount - 1, inComponent: 0, animated: false)
        childPicker.selectRow(childCount, inComponent: 0, animated: false)
        infantPicker.selectRow(infantCount, inComponent: 0, animated: false)
    }
}

extension PassengerCell: PassengerPickerViewDelegate {
    func passengerPickerCell(_ passengerPickerView: PassengerPickerView, didUpdate option: PassengerOption) {
        self.update(option)
        delegate?.passengerCell(self, didUpdate: option)
    }
}


