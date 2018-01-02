//
//  PillButton.swift
//  TakeFlight
//
//  Created by Justin Erickson on 12/6/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import UIKit

@IBDesignable
class PillButton: UIButton {
    
    // MARK: Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupView()
    }
    
    // MARK: Setup
    
    func setupView() {
        layer.cornerRadius = self.frame.height / 2
        clipsToBounds = true
    }
    
    override func prepareForInterfaceBuilder() {
        setupView()
    }
}
