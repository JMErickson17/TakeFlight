//
//  FlightDetailsVC.swift
//  TakeFlight
//
//  Created by Justin Erickson on 11/13/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import UIKit
import Firebase

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
    
    private lazy var bookFlightContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.7
        return view
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        return label
    }()
    
    private lazy var bookFlightButton: BookNowButton = {
        let button = BookNowButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowRadius = 5
        button.layer.shadowOpacity = 0.5
        button.layer.shadowOffset = CGSize.zero
        button.addTarget(self, action: #selector(saveFlight), for: .touchUpInside)
        return button
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
        
        view.backgroundColor = #colorLiteral(red: 0.9254901961, green: 0.9254901961, blue: 0.9254901961, alpha: 1)
        self.tabBarController?.tabBar.isHidden = true
        self.setPrice(to: flightData.saleTotal)
        self.title = flightData.shortDescription
        
        view.addSubview(bookFlightContainerView)
        NSLayoutConstraint.activate([
            bookFlightContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bookFlightContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bookFlightContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bookFlightContainerView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        bookFlightContainerView.addSubview(priceLabel)
        NSLayoutConstraint.activate([
            priceLabel.leadingAnchor.constraint(equalTo: bookFlightContainerView.leadingAnchor, constant: 20),
            priceLabel.centerYAnchor.constraint(equalTo: bookFlightContainerView.centerYAnchor)
        ])
        
        bookFlightContainerView.addSubview(bookFlightButton)
        NSLayoutConstraint.activate([
            bookFlightButton.trailingAnchor.constraint(equalTo: bookFlightContainerView.trailingAnchor, constant: -20),
            bookFlightButton.centerYAnchor.constraint(equalTo: bookFlightContainerView.centerYAnchor),
            bookFlightButton.heightAnchor.constraint(equalTo: bookFlightContainerView.heightAnchor, multiplier: 0.70),
            bookFlightButton.widthAnchor.constraint(equalTo: bookFlightContainerView.widthAnchor, multiplier: 0.30)
        ])
        
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bookFlightContainerView.topAnchor)
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
    
    private func setPrice(to price: Double) {
        let price = price as NSNumber
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        priceLabel.text = formatter.string(from: price)
    }
    
    @objc func saveFlight() {
        let firebaseStorage = FirebaseStorageService(storage: Storage.storage())
        let userService: FirebaseUserService = FirebaseUserService(database: Firestore.firestore(), userStorage: firebaseStorage)
        userService.saveToCurrentUser(flightData: flightData!) { (error) in
            if let error = error { print(error) }
        }
    }
}
