//
//  TakeoffLoadingView.swift
//  TakeFlight
//
//  Created by Justin Erickson on 12/13/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import UIKit

class TakeoffLoadingView: UIView, CAAnimationDelegate {
    
    // MARK: Constants
    
    private struct Constants {
        static let runwayWidth: CGFloat = 100
        static let runwayLength: CGFloat = 1000
        static let runwayLineWidth: CGFloat = 4
        static let runwayDashes: [CGFloat] = [50, 50]
    }
    
    // MARK: Properties
    
    //weak var delegate: TakeoffLoadingViewDelegate?
    
    private lazy var airplaneLayer: CALayer = {
        let layer = CALayer()
        layer.contents = #imageLiteral(resourceName: "Airplane Icon").cgImage! as Any
        layer.frame = CGRect(x: (bounds.midX - 87.5), y: (bounds.midX - 175), width: 175, height: 175)
        return layer
    }()
    
    private lazy var takeOffAnimation: CABasicAnimation = {
        let animation = CABasicAnimation(keyPath: "transform.translation.y")
        animation.fromValue = 0
        animation.toValue = -bounds.height
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        animation.duration = 2
        animation.beginTime = CACurrentMediaTime() + 2
        animation.isRemovedOnCompletion = true
        return animation
    }()
    
    private lazy var runwayLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.frame = CGRect(x: bounds.midX - Constants.runwayWidth / 2, y: bounds.midY - Constants.runwayLength, width: Constants.runwayWidth, height: Constants.runwayLength)
        layer.borderWidth = Constants.runwayLineWidth
        
        let divider = UIBezierPath()
        divider.move(to: CGPoint(x: layer.bounds.midX, y: layer.bounds.maxY - 100))
        divider.addLine(to: CGPoint(x: layer.bounds.midX, y: layer.bounds.minY))
    
        layer.path = divider.cgPath
        layer.lineWidth = Constants.runwayLineWidth
        layer.lineDashPattern = Constants.runwayDashes as [NSNumber]
        layer.fillColor = nil
        layer.strokeColor = UIColor.black.cgColor
        return layer
    }()
    
    private lazy var runwayAnimation: CABasicAnimation = {
        let animation = CABasicAnimation(keyPath: "transform.translation.y")
        animation.fromValue = 0
        animation.toValue = Constants.runwayLength * 2
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        animation.duration = 4
        animation.isRemovedOnCompletion = true
        return animation
    }()
    
    
    
    // MARK: Lifecycle
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    // MARK: Setup
    
    private func setupView() {
        self.clipsToBounds = true
        self.backgroundColor = .white
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleAnimationTap)))
        runwayAnimation.delegate = self
    }
    
    // MARK: Drawing

    override func draw(_ rect: CGRect) {
        self.layer.addSublayer(runwayLayer)
        self.layer.addSublayer(airplaneLayer)
    }
    
    // MARK: Public API
    
    func performTakeoffAnimation(withCompletion completion: (() -> Void)? = nil) {
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            completion?()
        }
        airplaneLayer.add(takeOffAnimation, forKey: takeOffAnimation.keyPath)
        runwayLayer.add(runwayAnimation, forKey: runwayAnimation.keyPath)
        CATransaction.commit()
    }
    
    // MARK: Convenience
    
    @objc func handleAnimationTap() {
        performTakeoffAnimation()
    }

}
