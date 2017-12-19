//
//  FlightDataTableViewHeaderView.swift
//  TakeFlight
//
//  Created by Justin Erickson on 12/17/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import UIKit

class FlightDataTableViewHeaderView: UIView {
    
    var text: String? {
        didSet {
            label.text = text
        }
    }
    
    var attributedText: NSAttributedString? {
        didSet {
            label.attributedText = attributedText
        }
    }

    private lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.light)
        return label
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    private func setupView() {
        self.backgroundColor = .white
        
        self.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
