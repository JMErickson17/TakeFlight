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
    
    private lazy var applyButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.title = "Apply"
        button.target = self
        button.action = #selector(handleApplyButtonWasTapped)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let selectedMaxDuration = selectedMaxDuration  {
            durationPicker.selectRow(durations.index(of: selectedMaxDuration)!, inComponent: 0, animated: false)
        } else {
            durationPicker.selectRow(durations.index(of: durations.last!)!, inComponent: 0, animated: false)
        }
    }
    
    private func setupView() {
        durationPicker.delegate = self
        navigationItem.rightBarButtonItem = applyButton
        if selectedMaxDuration == nil {
            selectedMaxDuration = durations.last!
        }
    }
    
    @objc private func handleApplyButtonWasTapped() {
        if let selectedMaxDuration = selectedMaxDuration {
            delegate?.durationFilterVC(self, didUpdateMaxDurationTo: selectedMaxDuration)
            navigationController?.popViewController(animated: true)
        }
    }
}

// MARK: DurationFilterVC+UIPickerViewDelegate, UIPickerViewDataSource

extension DurationFilterVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedMaxDuration = durations[row]
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
