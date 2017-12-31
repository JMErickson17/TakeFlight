//
//  DurationFilterVC.swift
//  TakeFlight
//
//  Created by Justin Erickson on 12/27/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import UIKit

class DurationFilterVC: UIViewController {
    
    private struct Constants {
        static let minDuration: Hour = 5
        static let maxDuration: Hour = 30
    }

    @IBOutlet weak var durationPicker: UIPickerView!
    
    weak var delegate: DurationFilterVCDelegate?
    
    var selectedMaxDuration: Hour? {
        didSet {
            if let selectedMaxDuration = selectedMaxDuration,
                selectedMaxDuration < Constants.minDuration ||
                    selectedMaxDuration > Constants.maxDuration {
                self.selectedMaxDuration = nil
            }
        }
    }
    
    private lazy var durations: [Hour] = {
        return Array(stride(from: Constants.minDuration, to: Constants.maxDuration + 1, by: 1))
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        durationPicker.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let selectedMaxDuration = selectedMaxDuration  {
            durationPicker.selectRow(durations.index(of: selectedMaxDuration)!, inComponent: 0, animated: false)
        } else {
            durationPicker.selectRow(durations.index(of: durations.last!)!, inComponent: 0, animated: false)
            
        }
    }
}

// MARK: DurationFilterVC+UIPickerViewDelegate, UIPickerViewDataSource

extension DurationFilterVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        delegate?.durationFilterVC(self, didUpdateMaxDurationTo: durations[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let duration = durations[row]
        return "\(duration) hours"
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return durations.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
}
