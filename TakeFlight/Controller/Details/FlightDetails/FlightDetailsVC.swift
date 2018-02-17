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
    
    private lazy var saveFlightBarButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: #imageLiteral(resourceName: "SaveFlight"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(saveFlightButtonWasTapped(_:)))
        return button
    }()
    
    // MARK: UI Elements
    
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
    
    private lazy var mapCard: MapCardVC = {
        let mapCard = MapCardVC()
        mapCard.view.translatesAutoresizingMaskIntoConstraints = false
        mapCard.view.layer.cornerRadius = 5
        mapCard.view.clipsToBounds = true
        return mapCard
    }()
    
    private lazy var longDescription: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .light)
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
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
        let flightPriceCardView = FlightPriceCardView()
        return flightPriceCardView
    }()


    // MARK: View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        scrollView.contentSize = CGSize(width: contentView.bounds.width, height: contentView.bounds.height)
    }
    
    // MARK: Setup
    
    private func setupView() {
        guard let flightData = flightData else { return }
        
        view.backgroundColor = #colorLiteral(red: 0.9254901961, green: 0.9254901961, blue: 0.9254901961, alpha: 1)
        self.tabBarController?.tabBar.isHidden = true
        self.title = flightData.shortDescription
        self.navigationItem.rightBarButtonItem = saveFlightBarButton
        configureActionButton()
        
        setupScrollView()
        setupLongDescriptionLabel()
        setupContentStackView()
        setupMapView()
        setupFlightCards()
        setupBookingDetailsCard()
        setupPriceDetailsCard()
    }
    
    private func setupScrollView() {
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
    }
    
    private func setupLongDescriptionLabel() {
        guard var flightData = flightData else { return }
        longDescription.text = flightData.longDescription()
        contentView.addSubview(longDescription)
        NSLayoutConstraint.activate([
            longDescription.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            longDescription.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            longDescription.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
            ])
    }
    
    private func setupContentStackView() {
        contentView.addSubview(contentStackView)
        NSLayoutConstraint.activate([
            contentStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            contentStackView.topAnchor.constraint(equalTo: longDescription.bottomAnchor, constant: 20),
            contentStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            contentStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
            ])
    }
    
    private func setupMapView() {
        guard let flightData = flightData else { return }
        
        add(mapCard)
        contentStackView.addArrangedSubview(mapCard.view)
        NSLayoutConstraint.activate([
            mapCard.view.heightAnchor.constraint(equalToConstant: 250)
        ])
        
        let airportService = appDelegate.firebaseAirportService!
        if let origin = airportService.airport(withIdentifier: flightData.departingFlight.originAirportCode),
            let destination = airportService.airport(withIdentifier: flightData.departingFlight.destinationAirportCode) {
            mapCard.addFlightPathAnnotations(from: origin.coordinates, to: destination.coordinates)
        }
    }

    private func setupFlightCards() {
        guard let flightData = flightData else { return }
        departingFlightCardView.setupCard(withFlight: flightData.departingFlight)
        contentStackView.addArrangedSubview(departingFlightCardView)
        
        if let returningFlight = flightData.returningFlight {
            returningFlightCardView.setupCard(withFlight: returningFlight)
            contentStackView.addArrangedSubview(returningFlightCardView)
        }
    }
    
    private func setupBookingDetailsCard() {
        guard let flightData = flightData else { return }
        let bookingCode = flightData.completeBookingCode
        let refundable = (flightData.refundable ?? false) == true ? "Yes" : "No"
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        let latestTicketingTime = flightData.latestTicketingTime.toLocalDateAndTimeString(withFormatter: dateFormatter)
        bookingDetailsCardView.configureView(withBookingCode: bookingCode, refundable: refundable, latestTicketingTime: latestTicketingTime,
                                             adultCount: flightData.adultCount, childCount: flightData.childCount, infantCount: flightData.infantCount)
        contentStackView.addArrangedSubview(bookingDetailsCardView)
    }
    
    private func setupPriceDetailsCard() {
        guard let flightData = flightData else { return }
        contentStackView.addArrangedSubview(flightPriceCardView)
        flightPriceCardView.configureView(withPassengers: flightData.passengerCountString,
                                   saleFare: "\(flightData.saleFareTotal.asCurrencyString()!) x\(flightData.passengerCount)",
                                   saleTax: flightData.saleTaxTotal.asCurrencyString()!,
                                   saleTotal: flightData.saleTotal.asCurrencyString()!
        )
    }

    private func configureActionButton() {
        if flightIsSaved {
            saveFlightBarButton.image = #imageLiteral(resourceName: "DeleteFlight")
        } else {
            saveFlightBarButton.image = #imageLiteral(resourceName: "SaveFlight")
        }
    }
    
    @objc private func saveFlightButtonWasTapped(_ sender: UIBarButtonItem) {
        if flightIsSaved {
            deleteSavedFlight()
        } else {
            saveFlight()
        }
    }

    private func saveFlight() {
        userService.saveToCurrentUser(flightData: flightData!) { [weak self] (error) in
            if let error = error { print(error) }
            self?.flightIsSaved = true
            if let navigationController = self?.navigationController {
                let notification = DropDownNotification(text: "Flight saved")
                notification.presentNotification(onViewController: navigationController, forDuration: 3)
            }
        }
    }
    
    private func deleteSavedFlight() {
        guard let uid = flightData?.uid else { return }
        userService.delete(savedFlightWithUID: uid) { [weak self] error in
            if let error = error { return print(error) }
            self?.flightIsSaved = false
            if self?.navigationController?.viewControllers[0] is ProfileVC {
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }
}
