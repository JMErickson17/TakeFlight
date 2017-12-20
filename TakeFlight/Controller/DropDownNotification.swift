//
//  DropDownNotification.swift
//  TakeFlight
//
//  Created by Justin Erickson on 12/19/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import UIKit

class DropDownNotification {
    
    // MARK: Properties
    
    lazy var notificationView: NotificationView = {
        let notificationView = NotificationView()
        notificationView.translatesAutoresizingMaskIntoConstraints = false
        return notificationView
    }()
    
    // MARK: Lifecycle
    
    init(text: String) {
        notificationView.text = text
    }
    
    // MARK: Convenience
    
    func presentNotification(onViewController viewController: UIViewController, forDuration duration: Double, completion: (() -> Void)? = nil) {
        viewController.view.addSubview(notificationView)
        
        let widthAnchor = notificationView.widthAnchor.constraint(equalToConstant: viewController.view.bounds.width * 0.90)
        let heightAnchor = notificationView.heightAnchor.constraint(equalToConstant: 75)
        let centerXAnchor = notificationView.centerXAnchor.constraint(equalTo: viewController.view.centerXAnchor)
        let bottomAnchor = notificationView.bottomAnchor.constraint(equalTo: viewController.view.topAnchor)
        NSLayoutConstraint.activate([ widthAnchor, heightAnchor, centerXAnchor, bottomAnchor ])
        viewController.view.updateConstraints()
        viewController.view.layoutIfNeeded()
        
        UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseIn, animations: {
            bottomAnchor.constant += self.notificationView.frame.height * 1.10
            viewController.view.layoutIfNeeded()
        }) { finished in
            if finished {
                UIView.animate(withDuration: 1.0, delay: duration, options: .curveEaseIn, animations: {
                    bottomAnchor.constant -= self.notificationView.frame.height * 1.5
                    viewController.view.layoutIfNeeded()
                }, completion: { (finished) in
                    if finished {
                        self.notificationView.removeFromSuperview()
                        completion?()
                    }
                })
            }
        }
    }
    
    func presentNotification(onNavigationController navigationController: UINavigationController, forDuration duration: Double, completion: (() -> Void)? = nil) {
        navigationController.navigationBar.addSubview(notificationView)
        
        let widthAnchor = notificationView.widthAnchor.constraint(equalToConstant: navigationController.navigationBar.bounds.width * 0.90)
        let heightAnchor = notificationView.heightAnchor.constraint(equalToConstant: 75)
        let centerXAnchor = notificationView.centerXAnchor.constraint(equalTo: navigationController.navigationBar.centerXAnchor)
        let bottomAnchor = notificationView.bottomAnchor.constraint(equalTo: navigationController.navigationBar.topAnchor)
        NSLayoutConstraint.activate([ widthAnchor, heightAnchor, centerXAnchor, bottomAnchor ])
        navigationController.navigationBar.layoutIfNeeded()
        
        
        UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseIn, animations: {
            bottomAnchor.constant += self.notificationView.frame.height * 1.10
            navigationController.navigationBar.layoutIfNeeded()
        }) { finished in
            if finished {
                UIView.animate(withDuration: 1.0, delay: duration, options: .curveEaseIn, animations: {
                    bottomAnchor.constant -= self.notificationView.frame.height * 1.5
                    navigationController.navigationBar.layoutIfNeeded()
                }, completion: { (finished) in
                    if finished {
                        self.notificationView.removeFromSuperview()
                        completion?()
                    }
                })
            }
        }
    }
    
}

// MARK:- NotificationView

class NotificationView: UIView {
    
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
