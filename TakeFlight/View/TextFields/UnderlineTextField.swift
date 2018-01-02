//
//  UnderlineTextField.swift
//  TakeFlight
//
//  Created by Justin Erickson on 1/1/18.
//  Copyright © 2018 Justin Erickson. All rights reserved.
//

import UIKit

class UnderlineTextField: UITextField {
    
    // MARK: Types
    
    private struct Constants {
        static let tintColor = UIColor.white
        static let borderWidth:CGFloat = 1
        static let leftPadding: CGFloat = 5
    }
    
    // MARK: Properties
    
    var iconImage: UIImage? {
        didSet {
            if let image = iconImage {
                iconImageView.image = image
            }
        }
    }
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private var inset: UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 30, bottom: -2.5, right: 25)
    }
    
    private lazy var border: CAShapeLayer = {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: bounds.minX, y: bounds.maxY))
        path.addLine(to: CGPoint(x: bounds.maxX, y: bounds.maxY))
        
        let border = CAShapeLayer()
        border.path = path.cgPath
        border.strokeColor = Constants.tintColor.cgColor
        border.lineWidth = Constants.borderWidth
        return border
    }()
    
    // MARK: Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupView()
    }
    
    // MARK: Setup
    
    private func setupView() {
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
        self.textColor = Constants.tintColor
        self.tintColor = Constants.tintColor
        self.leftViewMode = UITextFieldViewMode.always
        self.leftView = iconImageView
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
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.leftViewRect(forBounds: bounds)
        textRect.origin.x += Constants.leftPadding
        return textRect
    }
}
