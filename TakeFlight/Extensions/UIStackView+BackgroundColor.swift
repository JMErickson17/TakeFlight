//
//  UIStackView+BackgroundColor.swift
//  TakeFlight
//
//  Created by Justin Erickson on 1/31/18.
//  Copyright © 2018 Justin Erickson. All rights reserved.
//

import UIKit

extension UIStackView {
    func setBackgroundColor(to color: UIColor) {
        let subview = UIView(frame: bounds)
        subview.backgroundColor = color
        subview.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(subview, at: 0)
    }
}
