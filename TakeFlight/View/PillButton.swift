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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupView()
    }
    
    func setupView() {
        layer.cornerRadius = self.frame.height / 2
    }
    
    override func prepareForInterfaceBuilder() {
        setupView()
    }
}
