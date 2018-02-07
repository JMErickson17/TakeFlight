//
//  PickerVC.swift
//  TakeFlight
//
//  Created by Justin Erickson on 12/31/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import UIKit

class PickerVC: UIViewController {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    private lazy var applyButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Apply", for: .normal)
        return button
    }()
    
    private lazy var pickerView: UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }

    private func setupView() {
        view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20)
        ])
        
        view.addSubview(applyButton)
        NSLayoutConstraint.activate([
            applyButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 8),
            applyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 8)
        ])
        
        view.addSubview(pickerView)
        NSLayoutConstraint.activate([
            pickerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pickerView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            pickerView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}
