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
    
    private var airportService: AirportService
    
    private lazy var headerImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.image = #imageLiteral(resourceName: "SkyHeaderImage")
        imageView.layer.shadowColor = #colorLiteral(red: 0.4087824948, green: 0.4343314007, blue: 0.4343314007, alpha: 1)
        imageView.layer.shadowRadius = 10
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
    
    private lazy var carrierImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var carrierLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 24, weight: UIFont.Weight.light)
        label.textAlignment = .left
        label.textColor = .white
        return label
    }()
    
    private lazy var carrierStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [carrierLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        return stackView
    }()
    
    private lazy var dividingLine: LineView = {
        let lineView = LineView()
        lineView.translatesAutoresizingMaskIntoConstraints = false
        return lineView
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.regular)
        label.textColor = .white
        return label
    }()
    
    private lazy var segmentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 10
        return stackView
    }()
    
    private lazy var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter
    }()
    
    // MARK: Lifecycle
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder: ) has not been implemented")
    }
    
    override init(frame: CGRect) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        airportService = appDelegate.firebaseAirportService!
        
        super.init(frame: frame)
        
        setupView()
    }
    
    // MARK: Setup
    
    private func setupView() {
        backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        layer.cornerRadius = 5
        clipsToBounds = true
        addShadow()
        
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
        
        addSubview(carrierImage)
        NSLayoutConstraint.activate([
            carrierImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            carrierImage.topAnchor.constraint(equalTo: headerImage.bottomAnchor, constant: 20),
            carrierImage.heightAnchor.constraint(equalToConstant: 40),
            carrierImage.widthAnchor.constraint(equalToConstant: 40)
        ])
        
        addSubview(carrierStackView)
        NSLayoutConstraint.activate([
            carrierStackView.leadingAnchor.constraint(equalTo: carrierImage.trailingAnchor, constant: 20),
            carrierStackView.centerYAnchor.constraint(equalTo: carrierImage.centerYAnchor),
            carrierStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
        
        addSubview(dividingLine)
        NSLayoutConstraint.activate([
            dividingLine.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            dividingLine.topAnchor.constraint(equalTo: carrierStackView.bottomAnchor),
            dividingLine.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            dividingLine.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        addSubview(dateLabel)
        NSLayoutConstraint.activate([
            dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25),
            dateLabel.topAnchor.constraint(equalTo: dividingLine.bottomAnchor, constant: 10),
        ])
        
        addSubview(segmentStackView)
        NSLayoutConstraint.activate([
            segmentStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            segmentStackView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 10),
            segmentStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            segmentStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }
    
    private func addShadow() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = 10
    }
    
    func setupCard(withFlight flight: FlightData.Flight) {
        headerLabel.text = "\(flight.originAirportCode)-\(flight.destinationAirportCode)"
        carrierImage.image = flight.carrierLogo
        carrierLabel.text = flight.carrier.name
        dateLabel.text = flight.departureTime.toLocalDateAndTimeString(withFormatter: formatter)
        
        for segment in flight.segments {
            let segmentTimeline = SegmentTimelineView()
            segmentTimeline.configureSegmentTimelineView(withSegment: segment)
            segmentStackView.addArrangedSubview(segmentTimeline)
            
            if let connectionDuration = segment.connectionDuration {
                if let index = airportService.airports.index(where: { $0.iata == segment.destinationAirportCode }) {
                    let destinationAirport = airportService.airports[index]
                    let label = makeLayoverLabel(withDuration: connectionDuration, andAirport: destinationAirport)
                    segmentStackView.addArrangedSubview(label)
                }
            }
        }
    }
    
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

// MARK: - FlightCardView+SegmentTimelineView

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
                
//                if let connectionDuration = leg.connectionDuration {
//                    let label = makeLayoverLabel(withDuration: connectionDuration, andAirport: leg.destinationAirport)
//                    legStackView.addArrangedSubview(label)
//                }
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

// MARK: FlightCardView+LegTimeLineView

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

