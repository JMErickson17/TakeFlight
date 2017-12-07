//
//  BlueToWhiteGradientView.swift
//  TakeFlight
//
//  Created by Justin Erickson on 12/3/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import UIKit
import Hue

@IBDesignable class BlueGradientView: UIView {
    
    @IBInspectable var primary: UIColor = #colorLiteral(red: 0.1568627451, green: 0.3764705882, blue: 0.8705882353, alpha: 1) {
        didSet {
            setGradient()
        }
    }
    
    @IBInspectable var secondary: UIColor = #colorLiteral(red: 0.5607843137, green: 0.7568627451, blue: 1, alpha: 1) {
        didSet {
            setGradient()
        }
    }
    
    lazy var gradient = [primary, secondary].gradient { gradient in
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        
        gradient.frame = self.bounds
        return gradient
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setGradient()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        
        setGradient()
    }
 
    func setGradient () {
        self.layer.insertSublayer(gradient, at: 0)
    }
    
}
