//
//  OriginTextFieldHeaderView.swift
//  TakeFlight
//
//  Created by Justin Erickson on 3/2/18.
//  Copyright © 2018 Justin Erickson. All rights reserved.
//

import UIKit

class OriginTextFieldHeaderView: UIView {

    // MARK: Properties
    
    private let fromLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Flights From"
        return label
    }()
    
    let textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont.boldSystemFont(ofSize: 18)
        textField.textColor = UIColor.primaryBlue
        textField.contentVerticalAlignment = .bottom
        return textField
    }()
    
    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.spacing = 5
        return stackView
    }()
    
    // MARK: Initialization
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    convenience init() {
        self.init(frame: .zero)
        
        setupView()
    }
    
    // MARK: Setup
    
    private func setupView() {
        addSubview(contentStackView)
        NSLayoutConstraint.activate([
            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            contentStackView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
        
        contentStackView.addArrangedSubview(fromLabel)
        NSLayoutConstraint.activate([
            fromLabel.widthAnchor.constraint(equalToConstant: 95)
        ])
        
        contentStackView.addArrangedSubview(textField)
    }
    
    // MARK: Public API
    
    func endEditing() {
        self.textField.endEditing(true)
    }
}
