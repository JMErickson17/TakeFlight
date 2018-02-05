//
//  PassengerPickerView.swift
//  TakeFlight
//
//  Created by Justin Erickson on 2/3/18.
//  Copyright © 2018 Justin Erickson. All rights reserved.
//

import UIKit

protocol PassengerPickerViewDelegate: class {
    func passengerPickerCell(_ passengerPickerView: PassengerPickerView, didUpdate option: PassengerOption)
}

class PassengerPickerView: UIPickerView {

    weak var passengerDelegate: PassengerPickerViewDelegate?
    
    var possibleNumberOfPassengers = Array(0...8)
    
    var passengerOption: PassengerOption? {
        didSet {
            if let passengerOption = passengerOption, let index = possibleNumberOfPassengers.index(of: passengerOption.value) {
                selectRow(index, inComponent: 0, animated: false)
            }
        }
    }
    
    func updatePassengerOption(to value: Int) {
        guard let passengerOption = passengerOption else { return }
        
        switch passengerOption {
        case .adultPassengers(_):
            self.passengerOption = .adultPassengers(value)
        case .childPassengers(_):
            self.passengerOption = .childPassengers(value)
        case .infantPassengers(_):
            self.passengerOption = .infantPassengers(value)
        }
    }
}

extension PassengerPickerView: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return possibleNumberOfPassengers.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(possibleNumberOfPassengers[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let _ = passengerOption else { return }
        let value = possibleNumberOfPassengers[row]
        self.updatePassengerOption(to: value)
        passengerDelegate?.passengerPickerCell(self, didUpdate: self.passengerOption!)
    }
    
    
}
