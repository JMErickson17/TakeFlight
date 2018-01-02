//
//  LoggedInStatusView.swift
//  TakeFlight
//
//  Created by Justin Erickson on 12/19/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import UIKit

class LoggedInStatusView: UIView {
    
    // MARK: Properties
    
    weak var delegate: LoggedInStatusViewDelegate?
    
    var loggedInViewIsVisible: Bool {
        return !loggedInView.isHidden
    }
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var loggedInView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var loggedInLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12, weight: .light)
        label.textColor = UIColor.white
        label.numberOfLines = 2
        return label
    }()
    
    private var loggedInAsText: NSMutableAttributedString {
        let attributes: [NSAttributedStringKey: Any] = [
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12, weight: .light),
            NSAttributedStringKey.foregroundColor: UIColor.white
        ]
        return NSMutableAttributedString(string: "Logged in as\n", attributes: attributes)
    }
    
    private var emailLabelAttributes: [NSAttributedStringKey: Any] {
        return [
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14, weight: .regular),
            NSAttributedStringKey.foregroundColor: UIColor.white
        ]
    }
    
    private lazy var loggedOutView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var loginButtonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.spacing = 20
        stackView.addArrangedSubview(loginButton)
        stackView.addArrangedSubview(signupButton)
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
    
    // MARK: Lifecycle
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    // MARK: Setup
    
    private func setupView() {
        
        self.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        containerView.addSubview(loggedInView)
        NSLayoutConstraint.activate([
            loggedInView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            loggedInView.topAnchor.constraint(equalTo: containerView.topAnchor),
            loggedInView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            loggedInView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        loggedInView.addSubview(loggedInLabel)
        NSLayoutConstraint.activate([
            loggedInLabel.centerXAnchor.constraint(equalTo: loggedInView.centerXAnchor),
            loggedInLabel.centerYAnchor.constraint(equalTo: loggedInView.centerYAnchor),
            loggedInLabel.widthAnchor.constraint(equalTo: loggedInView.widthAnchor, multiplier: 0.90)
        ])
        
        containerView.addSubview(loggedOutView)
        NSLayoutConstraint.activate([
            loggedOutView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            loggedOutView.topAnchor.constraint(equalTo: containerView.topAnchor),
            loggedOutView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            loggedOutView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        loggedOutView.addSubview(loginButtonsStackView)
        NSLayoutConstraint.activate([
            loginButtonsStackView.leadingAnchor.constraint(equalTo: loggedOutView.leadingAnchor),
            loginButtonsStackView.topAnchor.constraint(equalTo: loggedOutView.topAnchor),
            loginButtonsStackView.trailingAnchor.constraint(equalTo: loggedOutView.trailingAnchor),
            loginButtonsStackView.bottomAnchor.constraint(equalTo: loggedOutView.bottomAnchor)
        ])
        
        loginButton.addTarget(self, action: #selector(loginButtonWasTapped), for: .touchUpInside)
        signupButton.addTarget(self, action: #selector(signupButtonWasTapped), for: .touchUpInside)
        
        configureViewForCurrentUser(animated: false)
    }
    
    // MARK: Convenience
    
    func configureViewForCurrentUser(animated: Bool) {
        if let currentUser = UserDataService.instance.currentUser {
            let loggedInText = currentUser.fullName ?? currentUser.email
            setLoggedInLabel(to: loggedInText)
            transitionToLoggedInView(animated: animated)
        } else {
            setLoggedInLabel(to: "")
            transitionToLoggedOutView(animated: animated)
        }
    }
    
    private func transitionToLoggedInView(animated: Bool) {
        if animated {
            UIView.transition(with: containerView, duration: 1.0, options: [.transitionFlipFromTop], animations: {
                self.loggedOutView.isHidden = true
                self.loggedInView.isHidden = false
            })
        } else {
            self.loggedOutView.isHidden = true
            self.loggedInView.isHidden = false
        }
    }
    
    private func transitionToLoggedOutView(animated: Bool) {
        if animated {
            UIView.transition(with: containerView, duration: 1.0, options: [.transitionFlipFromBottom], animations: {
                self.loggedOutView.isHidden = false
                self.loggedInView.isHidden = true
            })
        } else {
            self.loggedOutView.isHidden = false
            self.loggedInView.isHidden = true
        }
    }
    
    private func setLoggedInLabel(to text: String) {
        let attributedText = loggedInAsText
        let text = NSMutableAttributedString(string: text, attributes: emailLabelAttributes)
        attributedText.append(text)
        loggedInLabel.attributedText = attributedText
    }
    
    @objc private func loginButtonWasTapped() {
        delegate?.loggedInStatusView(self, loginButtonWasTapped: true)
    }
    
    @objc private func signupButtonWasTapped() {
        delegate?.loggedInStatusView(self, signupButtonWasTapped: true)
    }
}
