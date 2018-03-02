//
//  UITextField+Padding.swift
//  TakeFlight
//
//  Created by Justin Erickson on 3/2/18.
//  Copyright © 2018 Justin Erickson. All rights reserved.
//

import UIKit

extension UITextField {
    func setPadding(left padding: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}

