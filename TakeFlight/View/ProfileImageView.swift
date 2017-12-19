//
//  ProfileImageView.swift
//  TakeFlight
//
//  Created by Justin Erickson on 12/18/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import UIKit

@IBDesignable
class ProfileImageView: UIImageView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupView()
    }
    
    private func setupView() {
        self.layer.cornerRadius = frame.width / 2
        self.clipsToBounds = true
    }
    
    override func prepareForInterfaceBuilder() {
        setupView()
    }
}
