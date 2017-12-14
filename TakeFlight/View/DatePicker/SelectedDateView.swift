//
//  SelectedDateView.swift
//  TakeFlight
//
//  Created by Justin Erickson on 11/27/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import UIKit
import JTAppleCalendar

class SelectedDateView: UIView {
    
    // MARK: Types
    
    private struct Constants {
        static let circleLineWidth: CGFloat = 5
        static let circleLineColor: UIColor = UIColor(named: "PrimaryBlue")!
        static let circleBackgroundColor: UIColor = .white
        static let circleInset: CGFloat = 10
        
        static let connectingLineWidth: CGFloat = 15
        static let connectingLineColor: UIColor = .lightGray
    }
    
    private enum SelectedPosition {
        case none
        case left
        case middle
        case right
        case full
    }
    
    // MARK: Properties
    
    private var selectedPosition: SelectedPosition = .none {
        didSet {
            self.setNeedsLayout()
            self.setNeedsDisplay()
        }
    }
    
    private var centerLeft: CGPoint {
        return CGPoint(x: bounds.minX, y: bounds.midY)
    }

    private var centerPoint: CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    private var centerRight: CGPoint {
        return CGPoint(x: bounds.maxX, y: bounds.midY)
    }
    
    // MARK: Life Cycle
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .clear
    }
    
    // MARK: Presentation
    
    override func draw(_ rect: CGRect) {
        switch selectedPosition {
        case .none: break
        case .left:
            drawConnectingLine(forPosition: .left)
            drawEndPoint(inRect: rect)
        case .middle:
            drawConnectingLine(forPosition: .middle)
        case .right:
            drawConnectingLine(forPosition: .right)
            drawEndPoint(inRect: rect)
        case .full:
            drawEndPoint(inRect: rect)
        }
    }
    
    // MARK: Public API
    
    func drawView(forState state: CellState) {
        switch state.selectedPosition() {
        case .none:
            selectedPosition = .none
        case .left:
            selectedPosition = .left
        case .middle:
            selectedPosition = .middle
        case .right:
            selectedPosition = .right
        case .full:
            selectedPosition = .full
        }
    }
    
    // MARK: Convenience
    
    private func drawEndPoint(inRect rect: CGRect) {
        guard selectedPosition != .middle else { return }
        let circlePath = UIBezierPath(ovalIn: rect.insetBy(dx: Constants.circleInset, dy: Constants.circleInset))
        circlePath.lineWidth = Constants.circleLineWidth
        Constants.circleBackgroundColor.setFill()
        circlePath.fill()
        Constants.circleLineColor.setStroke()
        circlePath.stroke()
    }
    
    private func drawConnectingLine(forPosition position: SelectedPosition) {
        let path = UIBezierPath()
        path.lineWidth = Constants.connectingLineWidth
        Constants.connectingLineColor.setStroke()
        
        switch position {
        case .none, .full: break
        case .left:
            path.move(to: centerPoint)
            path.addLine(to: centerRight)
        case .middle:
            path.move(to: centerLeft)
            path.addLine(to: centerRight)
        case .right:
            path.move(to: centerLeft)
            path.addLine(to: centerPoint)
        }
        
        path.stroke()
    }

}
