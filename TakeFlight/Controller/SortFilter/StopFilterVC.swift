//
//  StopFilterVC.swift
//  TakeFlight
//
//  Created by Justin Erickson on 12/27/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import UIKit

class StopFilterVC: UIViewController {
    
    @IBOutlet weak var maxStopPicker: UIPickerView!
    
    weak var delegate: StopFilterVCDelegate?
    
    var selectedMaxStops: MaxStops?
    
    private let maxStops: [MaxStops] = [
        .nonStop,
        .one,
        .two,
        .three,
        .four,
        .five,
        .six
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let selectedMaxStops = selectedMaxStops {
            maxStopPicker.selectRow(selectedMaxStops.rawValue, inComponent: 0, animated: false)
        } else {
            maxStopPicker.selectRow(maxStops.last!.rawValue, inComponent: 0, animated: false)
        }
    }

    private func setupView() {
        maxStopPicker.delegate = self
        
    }
}

// MARK: StopFilterVC+UIPickerViewDelegate, UIPickerViewDataSource

extension StopFilterVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let newMaxStops = maxStops[row]
        delegate?.stopFilterVC(self, didUpdateMaxStopsTo: newMaxStops)
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return maxStops[row].description
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return maxStops.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
}
