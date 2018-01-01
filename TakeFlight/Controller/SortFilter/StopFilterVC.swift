//
//  StopFilterVC.swift
//  TakeFlight
//
//  Created by Justin Erickson on 12/27/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import UIKit

class StopFilterVC: UIViewController {
    
    // MARK: Properties
    
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
    
    private lazy var applyButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.title = "Apply"
        button.target = self
        button.action = #selector(handleApplyButtonWasTapped)
        return button
    }()
    
    // MARK: Lifecycle
    
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
    
    // MARK: Setup

    private func setupView() {
        maxStopPicker.delegate = self
        navigationItem.rightBarButtonItem = applyButton
        if selectedMaxStops == nil {
            selectedMaxStops = maxStops.last!
        }
    }
    
    // MARK: Convenience
    
    @objc private func handleApplyButtonWasTapped() {
        if let selectedMaxStops = selectedMaxStops {
            delegate?.stopFilterVC(self, didUpdateMaxStopsTo: selectedMaxStops)
            navigationController?.popViewController(animated: true)
        }
    }
}

// MARK: StopFilterVC+UIPickerViewDelegate, UIPickerViewDataSource

extension StopFilterVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedMaxStops = maxStops[row]
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
