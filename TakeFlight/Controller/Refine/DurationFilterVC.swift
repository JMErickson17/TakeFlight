//
//  DurationFilterVC.swift
//  TakeFlight
//
//  Created by Justin Erickson on 12/27/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import UIKit

class DurationFilterVC: UIViewController {
    
    // MARK: Constants
    
    private struct Constants {
        static let minDuration: Hour = 5
        static let maxDuration: Hour = 30
    }
    
    // MARK: Properties

    @IBOutlet weak var durationPicker: UIPickerView!
    @IBOutlet weak var containerView: UIView!
    
    weak var delegate: DurationFilterVCDelegate?
    
    private lazy var durations: [Hour] = {
        return Array(stride(from: Constants.minDuration, to: Constants.maxDuration + 1, by: 1))
    }()
    
    var selectedMaxDuration: Hour? {
        didSet {
            if let selectedMaxDuration = selectedMaxDuration,
                selectedMaxDuration < Constants.minDuration ||
                    selectedMaxDuration > Constants.maxDuration {
                self.selectedMaxDuration = nil
            }
        }
    }
    
    // MARK: View Life Cycle
    
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
        
        durationPicker.delegate = self
        if selectedMaxDuration == nil {
            selectedMaxDuration = durations.last!
        }
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissView(_:))))
    }
    
    // MARK: Actions
    
    @IBAction func applyButtonWasTapped(_ sender: Any) {
        if let selectedMaxDuration = selectedMaxDuration {
            self.presentingViewController?.dismiss(animated: true, completion: {
                self.delegate?.durationFilterVC(self, didUpdateMaxDurationTo: selectedMaxDuration)
            })
        }
    }
    
    // MARK: Convenience
    
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
