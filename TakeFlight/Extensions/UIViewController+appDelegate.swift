//
//  UIViewController+AppDelegate.swift
//  TakeFlight
//
//  Created by Justin Erickson on 2/3/18.
//  Copyright © 2018 Justin Erickson. All rights reserved.
//

import UIKit

extension UIViewController {
    var appDelegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
}
