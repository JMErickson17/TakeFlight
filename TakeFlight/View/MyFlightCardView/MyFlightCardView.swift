//
//  MyFlightCardView.swift
//  TakeFlight
//
//  Created by Justin Erickson on 1/23/18.
//  Copyright © 2018 Justin Erickson. All rights reserved.
//

import UIKit
import Spring

class MyFlightCardView: UIView {
    
    // MARK: Types
    
    private enum CardState {
        case departingFlight
        case returningFlight
    }
    
    // MARK: Properties

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var longDescriptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var stopCountLabel: UILabel!
    @IBOutlet weak var originLabel: UILabel!
    @IBOutlet weak var departureTimeLabel: UILabel!
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var arrivalTimeLabel: UILabel!
    @IBOutlet weak var airlineLabel: UILabel!
    @IBOutlet weak var flightTypeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var airplaneImage: SpringImageView!
    
    private var flightData: FlightData?
    private var cardState: CardState = .departingFlight {
        didSet {
            configureCard(forState: cardState)
        }
    }
    
    // MARK: Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupView()
    }
    
    // MARK: Setup
    
    private func setupView() {
        Bundle.main.loadNibNamed("MyFlightCardView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.layer.cornerRadius = 5
        contentView.clipsToBounds = true
        
        let switchStateRecognizer = UITapGestureRecognizer(target: self, action: #selector(stateChangeWasTapped))
        airplaneImage.addGestureRecognizer(switchStateRecognizer)
    }
    
    // MARK: Configuration
    
    private func configureCard(forState state: CardState) {
        switch state {
        case .departingFlight:
            UIView.animate(withDuration: 0.5, animations: {
                self.airplaneImage.transform = CGAffineTransform(rotationAngle: CGFloat.pi + 3.12159)
            })
            
            UIView.transition(with: contentView,
                              duration: 0.5,
                              options: .transitionCrossDissolve,
                              animations: configureCardForDepartingFlight,
                              completion: nil)
            
        case .returningFlight:
            UIView.animate(withDuration: 0.5, animations: {
                self.airplaneImage.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            })
            
            UIView.transition(with: contentView,
                              duration: 0.5,
                              options: [.transitionCrossDissolve, .allowAnimatedContent],
                              animations: configureCardForReturningFlight,
                              completion: nil)
        }
    }
    
    private func configureCardForDepartingFlight() {
        guard var flightData = flightData else { return }
        self.longDescriptionLabel.text = flightData.longDescription()
        self.dateLabel.text = makeDateString(with: flightData.departingFlight.departureTime)
        self.durationLabel.text = makeDurationString(withDuration: flightData.departingFlight.duration)
        self.stopCountLabel.attributedText = makeStopCountString(with: flightData.departingFlight.stopCount)
        self.originLabel.text = flightData.departingFlight.originAirportCode
        self.departureTimeLabel.attributedText = makeTimeString(with: flightData.departingFlight.departureTime)
        self.destinationLabel.text = flightData.departingFlight.destinationAirportCode
        self.arrivalTimeLabel.attributedText = makeTimeString(with: flightData.departingFlight.arrivalTime)
        self.airlineLabel.text = flightData.departingFlight.carrier.name
        self.flightTypeLabel.text = (flightData.isRoundTrip ? "Round Trip" : "One Way")
        self.priceLabel.text = makePriceString(withPrice: flightData.saleTotal)
    }
    
    private func configureCardForReturningFlight() {
        guard var flightData = flightData else { return }
        guard let returningFlight = flightData.returningFlight else { return }
        
        self.longDescriptionLabel.text = flightData.longDescription()
        self.dateLabel.text = makeDateString(with: returningFlight.departureTime)
        self.durationLabel.text = makeDurationString(withDuration: returningFlight.duration)
        self.stopCountLabel.attributedText = makeStopCountString(with: returningFlight.stopCount)
        self.originLabel.text = returningFlight.originAirportCode
        self.departureTimeLabel.attributedText = makeTimeString(with: returningFlight.departureTime)
        self.destinationLabel.text = returningFlight.destinationAirportCode
        self.arrivalTimeLabel.attributedText = makeTimeString(with: returningFlight.arrivalTime)
        self.airlineLabel.text = returningFlight.carrier.name
        self.flightTypeLabel.text = "Round Trip"
        self.priceLabel.text = makePriceString(withPrice: flightData.saleTotal)
    }
    
    // MARK: Convenience
    
    @objc private func stateChangeWasTapped() {
        guard let flightData = flightData else { return }
        if cardState == .departingFlight {
            if flightData.isRoundTrip {
                self.cardState = .returningFlight
            } else {
                shakeAirplane()
            }
            
        } else if cardState == .returningFlight {
            self.cardState = .departingFlight
        }
    }
    
    private func shakeAirplane() {
        airplaneImage.animation = Spring.AnimationPreset.Swing.rawValue
        airplaneImage.curve = Spring.AnimationCurve.EaseInOutCubic.rawValue
        airplaneImage.force = 1.2
        airplaneImage.duration = 0.5
        airplaneImage.animate()
    }
    
    // MARK: Public API
    
    func configureCard(with flightData: FlightData) {
        self.flightData = flightData
        configureCardForDepartingFlight()
    }
}

// MARK:- MyFlightCardView+containingCell(isSelected: )

extension MyFlightCardView {
    func containingCell(isSelected: Bool) {
        if isSelected {
            contentView.backgroundColor = UIColor.lightGray
        } else {
            contentView.backgroundColor = UIColor.white
        }
    }
}

// TODO: Make FlightDataFormatter

extension MyFlightCardView {
    func makePriceString(withPrice price: Double) -> String {
        let price = price as NSNumber
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.roundingMode = .up
        formatter.roundingIncrement = 1
        return formatter.string(from: price) ?? ""
    }
    
    func makeTimeString(with dateAndTime: DateAndTimeZone) -> NSAttributedString {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        
        let departureString = dateAndTime.toLocalDateAndTimeString(withFormatter: formatter)
        return NSAttributedString(string: departureString)
    }
    
    func makeDurationString(withDuration duration: Int) -> String {
        let hours = duration / 60
        let minutes = duration % 60
        return "\(hours)h \(minutes)m"
    }
    
    func makeStopCountString(with stops: Int) -> NSAttributedString {
        var string: String
        var attributes = [NSAttributedStringKey: Any]()
        if stops == 0 {
            string = "Non-Stop"
            attributes[NSAttributedStringKey.foregroundColor] = UIColor.stopCountGreen
        } else {
            attributes[NSAttributedStringKey.foregroundColor] = UIColor.stopCountRed
            string = "\(stops) \((stops == 1 ? "stop" : "stops"))"
        }
        return NSAttributedString(string: string, attributes: attributes)
    }
    
    func makeDateString(with dateAndTime: DateAndTimeZone) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return dateAndTime.toLocalDateAndTimeString(withFormatter: formatter)
    }
}
