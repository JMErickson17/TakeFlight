//
//  FlightCardView.swift
//  TakeFlight
//
//  Created by Justin Erickson on 11/27/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import UIKit

class FlightCardView: UIView {
    
    // MARK: Properties
    
    private lazy var headerImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.image = #imageLiteral(resourceName: "SkyHeaderImage")
        imageView.layer.shadowColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        imageView.layer.shadowRadius = 15
        imageView.layer.shadowOpacity = 0.7
        return imageView
    }()
    
    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 36, weight: UIFont.Weight.light)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    private lazy var carrierLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 24, weight: UIFont.Weight.light)
        label.textAlignment = .left
        label.textColor = .white
        return label
    }()
    
    private lazy var bookingCodeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 24, weight: UIFont.Weight.regular)
        label.textAlignment = .left
        label.textColor = .white
        return label
    }()
    
    private lazy var carrierStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [carrierLabel, bookingCodeLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        return stackView
    }()
    
    private lazy var dividingLine: LineView = {
        let lineView = LineView()
        lineView.translatesAutoresizingMaskIntoConstraints = false
        return lineView
    }()
    
    let segmentDetails: SegmentDetailsView = {
        let segmentDetails = SegmentDetailsView()
        segmentDetails.translatesAutoresizingMaskIntoConstraints = false
        return segmentDetails
    }()
    
    // MARK: Lifecycle
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder: ) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    // MARK: Setup
    
    private func setupView() {
        backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        layer.cornerRadius = 5
        clipsToBounds = true
        
        addSubview(headerImage)
        NSLayoutConstraint.activate([
            headerImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerImage.topAnchor.constraint(equalTo: topAnchor),
            headerImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            headerImage.heightAnchor.constraint(equalToConstant: 75)
        ])
        
        headerImage.addSubview(headerLabel)
        NSLayoutConstraint.activate([
            headerLabel.leadingAnchor.constraint(equalTo: headerImage.leadingAnchor),
            headerLabel.topAnchor.constraint(equalTo: headerImage.topAnchor),
            headerLabel.trailingAnchor.constraint(equalTo: headerImage.trailingAnchor),
            headerLabel.bottomAnchor.constraint(equalTo: headerImage.bottomAnchor)
        ])
        
        addSubview(carrierStackView)
        NSLayoutConstraint.activate([
            carrierStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            carrierStackView.topAnchor.constraint(equalTo: headerImage.bottomAnchor, constant: 20),
            carrierStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
        
        addSubview(dividingLine)
        NSLayoutConstraint.activate([
            dividingLine.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            dividingLine.topAnchor.constraint(equalTo: carrierStackView.bottomAnchor),
            dividingLine.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            dividingLine.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        addSubview(segmentDetails)
        NSLayoutConstraint.activate([
            segmentDetails.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            segmentDetails.topAnchor.constraint(equalTo: dividingLine.bottomAnchor, constant: 20),
            segmentDetails.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            segmentDetails.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    
    func setupCard(withFlight flight: FlightData.Flight) {
        headerLabel.text = "\(flight.originAirportCode)-\(flight.destinationAirportCode)"
        carrierLabel.text = flight.carrier
        bookingCodeLabel.text = flight.bookingCode
    }
    
}

// MARK: FlightCardView+DetailsView

extension FlightCardView {
    
    class SegmentDetailsView: UIView {
        
        private var segment: FlightSegment?
        
        private var departingCircle: CAShapeLayer?
        private var arrivalCircle: CAShapeLayer?
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            self.backgroundColor = .clear
            self.layer.borderWidth = 1
            self.layer.borderColor = UIColor.black.cgColor
        }
        
        override func draw(_ rect: CGRect) {
            //guard let segment = segment else { return }
            let context = UIGraphicsGetCurrentContext()
            
            departingCircle = CAShapeLayer()
            departingCircle?.path = UIBezierPath(ovalIn: CGRect(x: 5, y: 5, width: 20, height: 20)).cgPath
            departingCircle?.fillColor = UIColor.clear.cgColor
            departingCircle?.strokeColor = UIColor.white.cgColor
            layer.addSublayer(departingCircle!)
            
            arrivalCircle = CAShapeLayer()
            arrivalCircle?.path = UIBezierPath(ovalIn: CGRect(x: 5, y: 50, width: 20, height: 20)).cgPath
            arrivalCircle?.fillColor = UIColor.clear.cgColor
            arrivalCircle?.strokeColor = UIColor.white.cgColor
            layer.addSublayer(arrivalCircle!)
            
            context?.saveGState()
            context?.move(to: CGPoint(x: 5, y: (departingCircle?.frame.maxY)! + 5))
            UIColor.white.setStroke()
            context?.setLineWidth(1)
            context?.addLine(to: CGPoint(x: 5, y: (arrivalCircle?.frame.minY)! - 5))
            context?.strokePath()
            context?.restoreGState()
            
            
            
        }
        
        func makeSegmentDetails(withSegment segment: FlightSegment) {
            self.segment = segment
        }
        
        private func makeCircle(ofSize size: CGFloat) -> CAShapeLayer {
            let rect = CGRect(x: 0, y: 0, width: size, height: size)
            let path = UIBezierPath(ovalIn: rect)
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = path.cgPath
            shapeLayer.fillColor = UIColor.clear.cgColor
            shapeLayer.strokeColor = UIColor.white.cgColor
            return shapeLayer
        }
        
    }
}

























