//
//  FlightCardView+LegTimelineView.swift
//  TakeFlight
//
//  Created by Justin Erickson on 2/6/18.
//  Copyright © 2018 Justin Erickson. All rights reserved.
//

import UIKit

extension FlightCardView {
    
    class LegTimeLineView: TimelineView {
        
        // MARK: Propeties
        
        private var leg: FlightSegment.Leg?
        private let detailsStackViewXInset: CGFloat = 10
        private let detailsStackViewYInset: CGFloat = 10
        private let detailImages: [String: UIImage] = [
            "duration": #imageLiteral(resourceName: "DetailsClockIcon"),
            "meal": #imageLiteral(resourceName: "DetailsKnifeForkIcon"),
            "wifi": #imageLiteral(resourceName: "DetailsWifiIcon"),
            "aircraft": #imageLiteral(resourceName: "DetailsAirplaneIcon"),
            "onTimePerformance": #imageLiteral(resourceName: "DetailsStopWatchIcon")
        ]
        
        lazy var detailsStackView: UIStackView = {
            let stackView = UIStackView()
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.axis = .vertical
            stackView.spacing = 10
            return stackView
        }()
        
        override var circleDiameter: CGFloat {
            get {
                return 10
            }
            set {
                self.circleDiameter = newValue
            }
        }
        
        // MARK: Licecycle
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder: ) has not been implemented")
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            self.setupView()
        }
        
        // MARK: Setup
        
        private func setupView() {
            self.backgroundColor = .clear
            contentView.addSubview(detailsStackView)
            NSLayoutConstraint.activate([
                detailsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: detailsStackViewXInset),
                detailsStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: detailsStackViewYInset),
                detailsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -detailsStackViewXInset),
                detailsStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -detailsStackViewYInset)
                ])
        }
        
        // MARK: Drawing
        
        override func draw(_ rect: CGRect) {
            guard let leg = leg else { return }
            drawCircle(at: topCircleLocation, ofSize: circleSize)
            draw(text: makeTimeString(fromDateAndTimeZone: leg.departureTime), at: topLabelLocation)
            drawCircle(at: bottomCircleLocation, ofSize: circleSize)
            draw(text: makeTimeString(fromDateAndTimeZone: leg.arrivalTime), at: bottomLabelLocation)
            drawConnectingLine()
        }
        
        // MARK: Convenience
        
        func configureLegTimelineView(withLeg leg: FlightSegment.Leg) {
            self.leg = leg
            
            let legDetails: [String: String] = [
                "duration": makeString(withDuration: leg.duration),
                "aircraft": leg.aircraft,
                "wifi": "",
                "meal": leg.meal ?? "",
                "onTimePerformance": makeString(withOnTimePerformance: leg.onTimePerformance)
            ]
            
            for (key, value) in legDetails where value != "" {
                let detailsView = IconAndLabelView()
                detailsView.image = detailImages[key]
                detailsView.text = value
                detailsStackView.addArrangedSubview(detailsView)
            }
            setNeedsLayout()
            setNeedsDisplay()
        }
        
        func makeString(withDuration duration: Int) -> String {
            let hours = duration / 60
            let minutes = duration % 60
            return "\(hours)h \(minutes)m"
        }
        
        func makeString(withOnTimePerformance onTimePerformance: Int?) -> String {
            guard let onTimePerformance = onTimePerformance else { return "" }
            return "\(onTimePerformance)% On Time"
        }
    }
}
