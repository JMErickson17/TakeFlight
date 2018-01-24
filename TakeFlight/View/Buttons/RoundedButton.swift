//
//  BookNowButton.swift
//  TakeFlight
//
//  Created by Justin Erickson on 12/26/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import UIKit

class RoundedButton: UIButton {

    // MARK: Properties
    
    private var titleAttributes: [NSAttributedStringKey: Any] = [
        NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18, weight: .regular),
        NSAttributedStringKey.foregroundColor: UIColor.white
    ]
    
    var buttonTitle: String? {
        didSet {
            setButtonTitle(to: buttonTitle)
        }
    }
    
    // MARK: Lifecycle
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView(with: nil, color: nil)
    }
    
    convenience init(title: String, color: UIColor) {
        self.init()
        
        setupView(with: title, color: color)
    }
    
    // MARK: Setup
    
    private func setupView(with title: String?, color: UIColor?) {
        self.layer.cornerRadius = 3
        self.backgroundColor = color ?? UIColor.blue
        setButtonTitle(to: title)
    }
    
    private func setButtonTitle(to title: String?) {
        guard let title = title else { return }
        let attributedTitle = NSAttributedString(string: title, attributes: titleAttributes)
        self.setAttributedTitle(attributedTitle, for: .normal)
    }

}
