//
//  BookNowButton.swift
//  TakeFlight
//
//  Created by Justin Erickson on 12/26/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import UIKit

class BookNowButton: UIButton {

    private var titleAttributes: [NSAttributedStringKey: Any] = [
        NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18, weight: .regular),
        NSAttributedStringKey.foregroundColor: UIColor.white
    ]
    
    private var buttonTitle: String {
        return "Book Now"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    private func setupView() {
        self.layer.cornerRadius = 3
        self.backgroundColor = UIColor(named: "StopCountGreen")
        let attributedTitle = NSAttributedString(string: buttonTitle, attributes: titleAttributes)
        self.setAttributedTitle(attributedTitle, for: .normal)
    }

}
