//
//  TooltipView.swift
//  TakeFlight
//
//  Created by Justin Erickson on 12/6/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import UIKit
import CoreGraphics

@IBDesignable
class TooltipView: UIView {
    
    var tooltipLocation: CGFloat = 0.7
    var tooltipWidth: CGFloat = 5
    var tooltipHeight: CGFloat = 5

    var fillColor: UIColor = .white
    var borderColor: UIColor = .white
    var borderWidth: CGFloat = 1
    var borderRadius: CGFloat = 5
    
    var shadowColor: UIColor = UIColor(red:0, green:0, blue:0, alpha:0.14)
    var shadowOffsetX: CGFloat = 0
    var shadowOffsetY: CGFloat = 2
    var shadowBlur: CGFloat = 10
    
    var width = 0
    var height = 0
    
    private var tooltipShapeLayer: CAShapeLayer?

    override func draw(_ rect: CGRect) {
        drawTooltipView(atLocation: tooltipLocation)
    }
    
    private func topLeft(_ x: CGFloat, _ y: CGFloat) -> CGPoint {
        return CGPoint(x: x, y: y)
    }
    
    private func topRight(_ x: CGFloat, _ y: CGFloat) -> CGPoint {
        return CGPoint(x: CGFloat(width) - x, y: y)
    }
    
    private func bottomLeft(_ x: CGFloat, _ y: CGFloat) -> CGPoint {
        return CGPoint(x: x, y: CGFloat(height) - y)
    }
    
    private func bottomRight(_ x: CGFloat, _ y: CGFloat) -> CGPoint {
        return CGPoint(x: CGFloat(width) - x, y: CGFloat(height) - y)
    }
    
    private func drawTooltipViewShape(atLocation location: CGFloat) -> CAShapeLayer {
        width = Int(bounds.width)
        height = Int(bounds.height)
        
        let path = UIBezierPath()
        
        path.move(to: topLeft(0, borderRadius))
        path.addCurve(to: topLeft(borderRadius, 0), controlPoint1: topLeft(0, borderRadius / 2), controlPoint2: topLeft(borderRadius / 2, 0))
        
        path.addLine(to: topRight(borderRadius, 0))
        path.addCurve(to: topRight(0, borderRadius), controlPoint1: topRight(borderRadius / 2, 0), controlPoint2: topRight(0, borderRadius / 2))
        
        path.addLine(to: bottomRight(0, borderRadius))
        path.addCurve(to: bottomRight(borderRadius, 0), controlPoint1: bottomRight(0, borderRadius / 2), controlPoint2: bottomRight(borderRadius / 2, 0))
        
        path.addLine(to: bottomLeft(borderRadius, 0))
        path.addCurve(to: bottomLeft(0, borderRadius), controlPoint1: bottomLeft(borderRadius / 2, 0), controlPoint2: bottomLeft(0, borderRadius / 2))
        path.close()
        
        let tipCenter = CGFloat.lerp(min: bounds.width, max: 0, norm: location)
        path.move(to: topLeft((bounds.width - tipCenter) - tooltipWidth, 0))
        path.addLine(to: topLeft((bounds.width - tipCenter), -tooltipHeight))
        path.addLine(to: topLeft((bounds.width - tipCenter) + tooltipWidth, 0))
        path.close()
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = fillColor.cgColor
        shapeLayer.strokeColor = borderColor.cgColor
        shapeLayer.lineWidth = CGFloat(borderWidth * 2)
        
        return shapeLayer
    }
    
    private func drawTooltipView(atLocation location: CGFloat) {
        width = Int(bounds.width)
        height = Int(bounds.height)
        
        let path = UIBezierPath()
        
        path.move(to: topLeft(0, borderRadius))
        path.addCurve(to: topLeft(borderRadius, 0), controlPoint1: topLeft(0, borderRadius / 2), controlPoint2: topLeft(borderRadius / 2, 0))
        
        path.addLine(to: topRight(borderRadius, 0))
        path.addCurve(to: topRight(0, borderRadius), controlPoint1: topRight(borderRadius / 2, 0), controlPoint2: topRight(0, borderRadius / 2))
        
        path.addLine(to: bottomRight(0, borderRadius))
        path.addCurve(to: bottomRight(borderRadius, 0), controlPoint1: bottomRight(0, borderRadius / 2), controlPoint2: bottomRight(borderRadius / 2, 0))

        path.addLine(to: bottomLeft(borderRadius, 0))
        path.addCurve(to: bottomLeft(0, borderRadius), controlPoint1: bottomLeft(borderRadius / 2, 0), controlPoint2: bottomLeft(0, borderRadius / 2))
        path.close()
        
        // Arrow
        let tipCenter = CGFloat.lerp(min: bounds.width, max: 0, norm: location)
        path.move(to: topLeft((bounds.width - tipCenter) - tooltipWidth, 0))
        path.addLine(to: topLeft((bounds.width - tipCenter), -tooltipHeight))
        path.addLine(to: topLeft((bounds.width - tipCenter) + tooltipWidth, 0))
        path.close()
        
        let shadowShape = CAShapeLayer()
        shadowShape.path = path.cgPath
        shadowShape.fillColor = fillColor.cgColor
        shadowShape.shadowColor = shadowColor.cgColor
        shadowShape.shadowOffset = CGSize(width: CGFloat(shadowOffsetX), height: CGFloat(shadowOffsetY))
        shadowShape.shadowRadius = CGFloat(shadowBlur)
        shadowShape.shadowOpacity = 0.8
        
        let borderShape = CAShapeLayer()
        borderShape.path = path.cgPath
        borderShape.fillColor = fillColor.cgColor
        borderShape.strokeColor = borderColor.cgColor
        borderShape.lineWidth = CGFloat(borderWidth*2)
        
        let fillShape = CAShapeLayer()
        fillShape.path = path.cgPath
        fillShape.fillColor = fillColor.cgColor
        
        self.layer.insertSublayer(shadowShape, at: 0)
        self.layer.insertSublayer(borderShape, at: 0)
        self.layer.insertSublayer(fillShape, at: 0)
    }
    
    
    func animateTooltip(to location: CGFloat, withDuration duration: Double, completion: ((Bool) -> Void)? = nil) {
        guard let previousToolTipShape = tooltipShapeLayer else { return }
        
        let newToolTipShape = drawTooltipViewShape(atLocation: location)
        let animation = CABasicAnimation(keyPath: "path")
        animation.fromValue = previousToolTipShape
        animation.toValue = newToolTipShape
        animation.duration = duration
        self.layer.add(animation, forKey: "pathAnimation")
        tooltipLocation = location
    }
}
