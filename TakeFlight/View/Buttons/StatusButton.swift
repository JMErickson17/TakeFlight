//
//  StatusButton.swift
//  TakeFlight
//
//  Created by Justin Erickson on 12/31/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import UIKit

class StatusButton: UIButton {
    
    private lazy var statusShape: CAShapeLayer = {
        let statusPath = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 5, height: 5))
        let statusShape = CAShapeLayer()
        statusShape.path = statusPath.cgPath
        statusShape.fillColor = UIColor(named: "AccentBlue")?.cgColor
        return statusShape
    }()
    
    private var statusShapeLocation: CGPoint {
        return CGPoint(x: bounds.maxX - 10, y: bounds.minY + 5)
    }
    
    var shouldShowstatusIndicator: Bool = false {
        didSet {
            if shouldShowstatusIndicator {
                statusShape.position = statusShapeLocation
                self.layer.addSublayer(statusShape)
            } else {
                statusShape.removeFromSuperlayer()
            }
        }
    }
}
