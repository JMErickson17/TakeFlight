//
//  FlightDetailsVC.swift
//  TakeFlight
//
//  Created by Justin Erickson on 11/13/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import UIKit

class FlightDetailsVC: UIViewController, UIScrollViewDelegate {
    
    // MARK: Properties
    
    var flightData: FlightData?
    
    private lazy var scrollView: UIScrollView = {
        var scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.isScrollEnabled = true
        scrollView.isPagingEnabled = false
        scrollView.showsVerticalScrollIndicator = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 1.0
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var longDescription: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.light)
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var departingFlightCardView: FlightCardView = {
        var flightCard = FlightCardView()
        flightCard.translatesAutoresizingMaskIntoConstraints = false
        return flightCard
    }()
    
    private lazy var returningFlightCardView: FlightCardView = {
        var flightCard = FlightCardView()
        flightCard.translatesAutoresizingMaskIntoConstraints = false
        return flightCard
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        scrollView.contentSize = CGSize(width: contentView.bounds.width, height: contentView.bounds.height)
    }

    private func setupView() {
        guard let flightData = flightData else { return }
        
        view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        self.title = flightData.shortDescription
        
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        scrollView.addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalToConstant: view.bounds.width)
        ])
        
        longDescription.text = flightData.longDescription
        contentView.addSubview(longDescription)
        NSLayoutConstraint.activate([
            longDescription.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            longDescription.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            longDescription.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
        
        departingFlightCardView.setupCard(withFlight: flightData.departingFlight)
        contentView.addSubview(departingFlightCardView)
        NSLayoutConstraint.activate([
            departingFlightCardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            departingFlightCardView.topAnchor.constraint(equalTo: longDescription.bottomAnchor, constant: 20),
            departingFlightCardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
        
        if let returningFlight = flightData.returningFlight {
            returningFlightCardView.setupCard(withFlight: returningFlight)
            contentView.addSubview(returningFlightCardView)
            NSLayoutConstraint.activate([
                returningFlightCardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
                returningFlightCardView.topAnchor.constraint(equalTo: departingFlightCardView.bottomAnchor, constant: 20),
                returningFlightCardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
                returningFlightCardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
            ])
        } else {
            NSLayoutConstraint.activate([
                departingFlightCardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
            ])
        }
        view.layoutSubviews()
    }
}