//
//  UnderlineTextField.swift
//  TakeFlight
//
//  Created by Justin Erickson on 1/1/18.
//  Copyright © 2018 Justin Erickson. All rights reserved.
//

import UIKit

class UnderlineTextField: UITextField {
    
    private struct Constants {
        static let borderWidth:CGFloat = 1
    }
    
    private var inset: UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 22, bottom: 0, right: 0)
    }
    
    private lazy var border: CALayer = {
        let border = CALayer()
        border.borderColor = UIColor.white.cgColor
        border.borderWidth = Constants.borderWidth
        border.frame = CGRect(x: 0,
                              y: self.frame.size.height - Constants.borderWidth,
                              width: self.frame.size.width,
                              height: self.frame.size.height)
        return border
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupView()
    }
    
    private func setupView() {
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
        self.textColor = .white
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, inset)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, inset)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, inset)
    }
}
