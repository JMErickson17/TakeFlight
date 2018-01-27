//
//  NotificationView.swift
//  TakeFlight
//
//  Created by Justin Erickson on 1/26/18.
//  Copyright © 2018 Justin Erickson. All rights reserved.
//

import UIKit
import Spring

class NotificationView: SpringView {
    
    // MARK: Properties
    
    var text: String? {
        didSet {
            label.text = text ?? nil
        }
    }
    
    var attributedText: NSAttributedString? {
        didSet {
            label.attributedText = attributedText ?? nil
        }
    }
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12, weight: .light)
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: Lifecycle
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    // MARK: Setup
    
    private func setupView() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 5
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 0.3
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = 10
        
        self.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            label.widthAnchor.constraint(lessThanOrEqualTo: self.widthAnchor, multiplier: 0.90)
        ])
    }
}
