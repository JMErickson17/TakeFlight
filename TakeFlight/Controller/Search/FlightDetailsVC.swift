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
    
    var flightIsSaved: Bool = false {
        didSet {
            configureActionButton()
        }
    }
    
    private lazy var userService: UserService = appDelegate.firebaseUserService!
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
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
        let view = UIView()
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
        let flightCard = FlightCardView()
        flightCard.translatesAutoresizingMaskIntoConstraints = false
        return flightCard
    }()
    
    private lazy var returningFlightCardView: FlightCardView = {
        let flightCard = FlightCardView()
        flightCard.translatesAutoresizingMaskIntoConstraints = false
        return flightCard
    }()
    
    private lazy var bookingDetailsCardView: BookingDetailsCardView = {
        let detailsCard = BookingDetailsCardView()
        detailsCard.translatesAutoresizingMaskIntoConstraints = false
        return detailsCard
    }()
    
    private lazy var flightPriceCardView: FlightPriceCardView = {
        let cardView = FlightPriceCardView()
        cardView.translatesAutoresizingMaskIntoConstraints = false
        return cardView
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
    
    private lazy var saveFlightButton: RoundedButton = {
        let button = RoundedButton(title: "Save Flight", color: UIColor.stopCountGreen)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowRadius = 5
        button.layer.shadowOpacity = 0.5
        button.layer.shadowOffset = CGSize.zero
        button.addTarget(self, action: #selector(saveFlight), for: .touchUpInside)
        return button
    }()
    
    private lazy var deleteFlightButton: RoundedButton = {
        let button = RoundedButton(title: "Delete Flight", color: UIColor.stopCountRed)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowRadius = 5
        button.layer.shadowOpacity = 0.5
        button.layer.shadowOffset = CGSize.zero
        button.addTarget(self, action: #selector(deleteSavedFlight), for: .touchUpInside)
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
        guard var flightData = flightData else { return }
        
        view.backgroundColor = #colorLiteral(red: 0.9254901961, green: 0.9254901961, blue: 0.9254901961, alpha: 1)
        self.tabBarController?.tabBar.isHidden = true
        self.priceLabel.text = makePriceString(with: flightData.saleTotal)
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
        
        configureActionButton()
        
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
        
        longDescription.text = flightData.longDescription()
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
                returningFlightCardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
            ])
            
            contentView.addSubview(bookingDetailsCardView)
            NSLayoutConstraint.activate([
                bookingDetailsCardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
                bookingDetailsCardView.topAnchor.constraint(equalTo: returningFlightCardView.bottomAnchor, constant: 20),
                bookingDetailsCardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
            ])
            
            contentView.addSubview(flightPriceCardView)
            NSLayoutConstraint.activate([
                flightPriceCardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
                flightPriceCardView.topAnchor.constraint(equalTo: bookingDetailsCardView.bottomAnchor, constant: 20),
                flightPriceCardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
                flightPriceCardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
            ])
        } else {
            contentView.addSubview(bookingDetailsCardView)
            NSLayoutConstraint.activate([
                bookingDetailsCardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
                bookingDetailsCardView.topAnchor.constraint(equalTo: departingFlightCardView.bottomAnchor, constant: 20),
                bookingDetailsCardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
            ])
            
            contentView.addSubview(flightPriceCardView)
            NSLayoutConstraint.activate([
                flightPriceCardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
                flightPriceCardView.topAnchor.constraint(equalTo: bookingDetailsCardView.bottomAnchor, constant: 20),
                flightPriceCardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
                flightPriceCardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
            ])
        }
        
        let bookingCode = flightData.completeBookingCode
        let refundable = (flightData.refundable ?? false) == true ? "Yes" : "No"
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        let latestTicketingTime = flightData.latestTicketingTime.toLocalDateAndTimeString(withFormatter: dateFormatter)
        bookingDetailsCardView.configureView(withBookingCode: bookingCode, refundable: refundable, latestTicketingTime: latestTicketingTime, adultCount: flightData.adultCount, childCount: flightData.childCount, infantCount: flightData.infantCount)
        
        let baseFare = makePriceString(with: flightData.baseFareTotal)
        let saleFare = makePriceString(with: flightData.saleFareTotal)
        let saleTax = makePriceString(with: flightData.saleTaxTotal)
        let saleTotal = makePriceString(with: flightData.saleTotal)
        flightPriceCardView.configureView(withBaseFare: baseFare, saleFare: saleFare, saleTax: saleTax, saleTotal: saleTotal)
        
        view.layoutSubviews()
    }
    
    private func configureActionButton() {
        [saveFlightButton, deleteFlightButton].forEach { $0.removeFromSuperview() }
        let actionButton = flightIsSaved ? deleteFlightButton : saveFlightButton
        
        bookFlightContainerView.addSubview(actionButton)
        NSLayoutConstraint.activate([
            actionButton.trailingAnchor.constraint(equalTo: bookFlightContainerView.trailingAnchor, constant: -20),
            actionButton.centerYAnchor.constraint(equalTo: bookFlightContainerView.centerYAnchor),
            actionButton.heightAnchor.constraint(equalTo: bookFlightContainerView.heightAnchor, multiplier: 0.70),
            actionButton.widthAnchor.constraint(equalTo: bookFlightContainerView.widthAnchor, multiplier: 0.30)
        ])
    }
    
    private func makePriceString(with price: Double) -> String? {
        let price = price as NSNumber
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter.string(from: price)
    }
    
    @objc func saveFlight() {
        userService.saveToCurrentUser(flightData: flightData!) { [weak self] (error) in
            if let error = error { print(error) }
            self?.flightIsSaved = true
            if let navigationController = self?.navigationController {
                let notification = DropDownNotification(text: "Flight saved")
                notification.presentNotification(onViewController: navigationController, forDuration: 3)
            }
        }
    }
    
    @objc func deleteSavedFlight() {
        guard let uid = flightData?.uid else { return }
        userService.delete(savedFlightWithUID: uid) { [weak self] error in
            if let error = error { return print(error) }
            self?.flightIsSaved = false
            self?.navigationController?.popViewController(animated: true)
        }
    }
}
