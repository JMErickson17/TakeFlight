//
//  LineView.swift
//  TakeFlight
//
//  Created by Justin Erickson on 12/11/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import UIKit

class LineView: UIView {
    
    // MARK: Properties

    var lineWidth: CGFloat = 1
    var lineColor = UIColor.white

    private var midPoint: CGFloat {
        return bounds.height / 2
    }
    
    // MARK: Lifecycle
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
    }
    
    // MARK: Drawing
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: midPoint))
        path.addLine(to: CGPoint(x: bounds.width, y: midPoint))
        path.lineWidth = lineWidth
        lineColor.setStroke()
        path.stroke()
    }
}
