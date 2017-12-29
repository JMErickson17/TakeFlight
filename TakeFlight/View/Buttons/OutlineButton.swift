//
//  OutlineButton.swift
//  TakeFlight
//
//  Created by Justin Erickson on 12/19/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import UIKit

class OutlineButton: UIButton {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }

    private func setupView() {
        self.clipsToBounds = true
        self.layer.cornerRadius = 3
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.white.cgColor
        self.backgroundColor = .clear
        self.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .light)
    }
}
