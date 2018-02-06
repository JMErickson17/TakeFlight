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
        imageView.image = #imageLiteral(resourceName: "SkyHeaderImage_3")
        return imageView
    }()
    
    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 36, weight: UIFont.Weight.light)
        label.textAlignment = .center
        label.textColor = .white
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowRadius = 3
        label.layer.shadowOpacity = 1.0
        label.layer.shadowOffset = CGSize(width: 2, height: 2)
        label.layer.masksToBounds = false
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
