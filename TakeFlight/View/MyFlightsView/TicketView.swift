//
//  TicketView.swift
//  TakeFlight
//
//  Created by Justin Erickson on 12/18/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import UIKit

@IBDesignable
class TicketView: UIView {

    private lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 48, weight: UIFont.Weight.regular)
        label.text = "Ticket View"
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupView()
    }
    
    override func draw(_ rect: CGRect) {
        let ticketRect = UIBezierPath(roundedRect: rect, cornerRadius: 5)
        let ticketShape = CAShapeLayer()
        ticketShape.path = ticketRect.cgPath
        ticketShape.fillColor = UIColor.white.cgColor
        ticketShape.strokeColor = UIColor.black.cgColor
        ticketShape.lineWidth = 0.1
        
        self.layer.addSublayer(ticketShape)
    }
    
    private func setupView() {
        self.clipsToBounds = true
        self.backgroundColor = .clear
        
//        addSubview(label)
//        NSLayoutConstraint.activate([
//            label.centerXAnchor.constraint(equalTo: centerXAnchor),
//            label.centerYAnchor.constraint(equalTo: centerYAnchor)
//        ])
    }

}
