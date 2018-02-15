//
//  UIViewController+Identifier.swift
//  TakeFlight
//
//  Created by Justin Erickson on 2/15/18.
//  Copyright © 2018 Justin Erickson. All rights reserved.
//

import UIKit

extension UIViewController {
    static var identifier: String {
        return String(describing: self)
    }
}
