//
//  ProfileImageView.swift
//  TakeFlight
//
//  Created by Justin Erickson on 12/18/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import UIKit

class ProfileImageView: UIImageView {
    
    // MARK: Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupView()
    }
    
    // MARK: Setup
    
    private func setupView() {
        self.layer.cornerRadius = frame.width / 2
        self.clipsToBounds = true
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 1
    }
    
}
