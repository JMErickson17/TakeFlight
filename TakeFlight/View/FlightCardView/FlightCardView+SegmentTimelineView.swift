//
//  FlightCardView+SegmentTimelineView.swift
//  TakeFlight
//
//  Created by Justin Erickson on 2/6/18.
//  Copyright © 2018 Justin Erickson. All rights reserved.
//

import UIKit

extension FlightCardView {
    
    class SegmentTimelineView: TimelineView {
        
        // MARK: Properties
        
        var segment: FlightSegment?
        
        let legStackView: UIStackView = {
            let stackView = UIStackView()
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.axis = .vertical
            stackView.spacing = 10
            return stackView
        }()
        
        // MARK: Lifecycle
        
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
            
            contentView.addSubview(legStackView)
            NSLayoutConstraint.activate([
                legStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                legStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
                legStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                legStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
                ])
        }
        
        // MARK: Drawing
        
        override func draw(_ rect: CGRect) {
            guard let segment = segment else { return }
            
            drawCircle(at: topCircleLocation, ofSize: circleSize)
            draw(text: makeAttributedString(fromString: segment.originAirportCode), at: topLabelLocation)
            drawCircle(at: bottomCircleLocation, ofSize: circleSize)
            draw(text: makeAttributedString(fromString: segment.destinationAirportCode), at: bottomLabelLocation)
            drawConnectingLine()
        }
        
        // MARK: Convenience
        
        func configureSegmentTimelineView(withSegment segment: FlightSegment) {
            self.segment = segment
            
            for leg in segment.legs {
                let legTimelineView = LegTimeLineView()
                legTimelineView.configureLegTimelineView(withLeg: leg)
                legStackView.addArrangedSubview(legTimelineView)
            }
            setNeedsLayout()
            setNeedsDisplay()
        }
        
        // TODO: Consolidate makeLayoverLabel into single helper class
        
        func makeLayoverLabel(withDuration duration: Int, andAirport airport: Airport?) -> UILabel {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.light)
            label.textColor = .white
            label.textAlignment = .center
            let durationString = makeString(withDuration: duration)
            
            if let airport = airport {
                label.text = "\(durationString) layover in \(airport.city.capitalized), \(airport.state)"
            } else {
                label.text = "\(durationString) layover"
            }
            
            return label
        }
        
        func makeString(withDuration duration: Int) -> String {
            let hours = duration / 60
            let minutes = duration % 60
            if hours == 0 {
                return "\(minutes)m"
            } else {
                return "\(hours)h \(minutes)m"
            }
        }
    }
}
