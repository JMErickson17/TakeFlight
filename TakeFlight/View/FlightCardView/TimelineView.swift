//
//  TimelineView.swift
//  TakeFlight
//
//  Created by Justin Erickson on 12/13/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import UIKit

class TimelineView: UIView {
    
    // MARK: Properties
    
    var labelXInset: CGFloat = 5
    var circleXInset: CGFloat = 10
    var circleYInset: CGFloat = 5
    var circleDiameter: CGFloat = 20
    var circleLineWidth: CGFloat = 1.0
    var circleStrokeColor: UIColor = .white
    var circleFillColor: UIColor = .clear
    var lineColor: UIColor = .white
    var lineDashes: [CGFloat] = [4, 4]
    var labelFontSize: CGFloat = 14
    
    lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    var circleSize: CGSize {
        return CGSize(width: circleDiameter, height: circleDiameter)
    }
    
    var topCircleLocation: CGPoint {
        return CGPoint(x: circleXInset, y: circleYInset)
    }
    
    var topLabelLocation: CGPoint {
        return CGPoint(x: circleXInset + circleDiameter + labelXInset, y: topCircleLocation.y + (circleDiameter / 2) - (labelFontSize / 2))
    }
    
    var bottomCircleLocation: CGPoint {
        return CGPoint(x: circleXInset, y: bounds.maxY - circleYInset - circleDiameter)
    }
    
    var bottomLabelLocation: CGPoint {
        return CGPoint(x: circleXInset + circleDiameter + labelXInset, y: bottomCircleLocation.y + (circleDiameter / 2) - (labelFontSize / 2))
    }
    
    var connectingLineXInset: CGFloat {
        return circleXInset + (circleDiameter / 2)
    }
    
    var connectingLineStartingPosition: CGPoint {
        return CGPoint(x: connectingLineXInset, y: topCircleLocation.y + circleDiameter + (circleDiameter * 0.25))
    }
    
    var connectingLineEndPosition: CGPoint {
        return CGPoint(x: connectingLineXInset, y: bottomCircleLocation.y - (circleDiameter * 0.25))
    }
    
    var contentViewXInset: CGFloat {
        return connectingLineXInset * 1.25
    }
    
    var contentViewYInset: CGFloat {
        return circleYInset + circleDiameter * 1.25
    }
    
    // MARK: Lifecycle
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupView()
    }
    
    // MARK: Setup
    
    private func setupView() {
        self.backgroundColor = .clear
        self.addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: contentViewXInset),
            contentView.topAnchor.constraint(equalTo: topAnchor, constant: contentViewYInset),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -contentViewXInset),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -contentViewYInset)
        ])
    }
    
    // MARK: Convenience
    
    func makeAttributedString(fromString string: String) -> NSAttributedString {
        let attributes: [NSAttributedStringKey: Any] = [
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: labelFontSize, weight: UIFont.Weight.light),
            NSAttributedStringKey.foregroundColor: UIColor.white
        ]
        return NSAttributedString(string: string, attributes: attributes)
    }
    
    func makeTimeString(fromDateAndTimeZone dateAndTimeZone: DateAndTimeZone) -> NSAttributedString {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        let string = dateAndTimeZone.toLocalDateAndTimeString(withFormatter: formatter)
        let attributes: [NSAttributedStringKey: Any] = [
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: labelFontSize, weight: UIFont.Weight.light),
            NSAttributedStringKey.foregroundColor: UIColor.white
        ]
        
        return NSAttributedString(string: string, attributes: attributes)
    }
    
    // MARK: Drawing
    
    func drawCircle(at location: CGPoint, ofSize size: CGSize) {
        let rect = CGRect(origin: location, size: size)
        let path = UIBezierPath(ovalIn: rect)
        path.lineWidth = circleLineWidth
        circleStrokeColor.setStroke()
        circleFillColor.setFill()
        path.stroke()
    }
    
    func drawConnectingLine() {
        let path = UIBezierPath()
        path.move(to: connectingLineStartingPosition)
        path.addLine(to: connectingLineEndPosition)
        path.setLineDash(lineDashes, count: lineDashes.count, phase: 0)
        path.lineCapStyle = .round
        lineColor.setStroke()
        path.stroke()
    }
    
    func draw(text: NSAttributedString, at location: CGPoint) {
        text.draw(at: location)
    }
}
