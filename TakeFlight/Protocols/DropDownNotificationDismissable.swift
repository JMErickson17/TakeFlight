//
//  DropDownNotificationDismissable.swift
//  TakeFlight
//
//  Created by Justin Erickson on 1/27/18.
//  Copyright © 2018 Justin Erickson. All rights reserved.
//

import UIKit

@objc protocol DropDownNotificationDismissable: UIGestureRecognizerDelegate {
    @objc func dismissGestureBegan(gesture: UIPanGestureRecognizer)
}
