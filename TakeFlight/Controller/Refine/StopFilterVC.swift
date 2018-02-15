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
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var maxStopPicker: UIPickerView!
    @IBOutlet weak var applyButton: UIButton!
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        addBackground()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        removeBackground()
    }
    
    // MARK: Setup

    private func setupView() {
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 1
        containerView.layer.shadowRadius = 20
        containerView.layer.shadowOffset = CGSize(width: 0, height: 15)
        containerView.layer.masksToBounds = false
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 10
        
        maxStopPicker.delegate = self
        if selectedMaxStops == nil {
            selectedMaxStops = maxStops.last!
        }
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissView(_:))))
    }
    
    // MARK: Convenience
    
    @IBAction func applyButtonWasTapped(_ sender: Any) {
        if let selectedMaxStops = selectedMaxStops {
            self.presentingViewController?.dismiss(animated: true, completion: {
                self.delegate?.stopFilterVC(self, didUpdateMaxStopsTo: selectedMaxStops)
            })
        }
    }
    
    @objc private func dismissView(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true)
    }
    
    private func addBackground() {
        UIView.animate(withDuration: 0.3) {
            self.view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5)
        }
    }
    
    private func removeBackground() {
        UIView.animate(withDuration: 0.3) {
            self.view.backgroundColor = .clear
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
