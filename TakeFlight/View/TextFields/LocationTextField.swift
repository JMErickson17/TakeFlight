//
//  LocationTextField.swift
//  TakeFlight
//
//  Created by Justin Erickson on 12/22/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import UIKit

class LocationTextField: UITextField {
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, UIEdgeInsetsMake(0, 5, 0, 5))
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, UIEdgeInsetsMake(0, 5, 0, 5))
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, UIEdgeInsetsMake(0, 5, 0, 5))
    }

}
