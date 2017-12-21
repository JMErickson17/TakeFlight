//
//  LoggedInStatusView.swift
//  TakeFlight
//
//  Created by Justin Erickson on 12/19/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import UIKit

@IBDesignable
class LoggedInStatusView: UIView {
    
    weak var delegate: LoggedInStatusViewDelegate?
    
    var isLoggedIn: Bool = false {
        didSet {
            configureView(forLoggedInStatus: isLoggedIn)
        }
    }
    
    var email: String? {
        didSet {
            userEmailLabel.text = email
        }
    }

    private lazy var loggedInStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.addArrangedSubview(loggedInAsLabel)
        stackView.addArrangedSubview(userEmailLabel)
        stackView.spacing = 2
        stackView.isHidden = true
        return stackView
    }()
    
    private lazy var loggedInAsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12, weight: .light)
        label.textColor = UIColor.white
        label.text = "Logged in as"
        return label
    }()
    
    private lazy var userEmailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor.white
        return label
    }()
    
    private lazy var loginButtonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.spacing = 20
        stackView.addArrangedSubview(loginButton)
        stackView.addArrangedSubview(signupButton)
        stackView.isHidden = true
        return stackView
    }()
    
    private lazy var loginButton: OutlineButton = {
        let button = OutlineButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Login", for: .normal)
        button.widthAnchor.constraint(equalToConstant: 100).isActive = true
        button.heightAnchor.constraint(equalToConstant: 30).isActive = true
        return button
    }()
    
    private lazy var signupButton: OutlineButton = {
        let button = OutlineButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Signup", for: .normal)
        button.widthAnchor.constraint(equalToConstant: 100).isActive = true
        button.heightAnchor.constraint(equalToConstant: 30).isActive = true
        return button
    }()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    private func setupView() {
        self.addSubview(loggedInStackView)
        NSLayoutConstraint.activate([
            loggedInStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            loggedInStackView.topAnchor.constraint(equalTo: topAnchor),
            loggedInStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            loggedInStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        self.addSubview(loginButtonsStackView)
        NSLayoutConstraint.activate([
            loginButtonsStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            loginButtonsStackView.topAnchor.constraint(equalTo: topAnchor),
            loginButtonsStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            loginButtonsStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        loginButton.addTarget(self, action: #selector(loginButtonWasTapped), for: .touchUpInside)
        signupButton.addTarget(self, action: #selector(signupButtonWasTapped), for: .touchUpInside)
        
        configureView(forLoggedInStatus: isLoggedIn)
    }

    private func configureView(forLoggedInStatus isLoggedIn: Bool) {
        if isLoggedIn {
            loggedInStackView.isHidden = false
            loginButtonsStackView.isHidden = true
        } else {
            loggedInStackView.isHidden = true
            loginButtonsStackView.isHidden = false
        }
        layoutIfNeeded()
    }
    
    @objc private func loginButtonWasTapped() {
        delegate?.loggedInStatusView(self, loginButtonWasTapped: true)
    }
    
    @objc private func signupButtonWasTapped() {
        delegate?.loggedInStatusView(self, signupButtonWasTapped: true)
    }
    
    override func prepareForInterfaceBuilder() {
        setupView()
    }
}
