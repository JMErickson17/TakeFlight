//
//  DestinationFlightsVC.swift
//  TakeFlight
//
//  Created by Justin Erickson on 2/20/18.
//  Copyright © 2018 Justin Erickson. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class DestinationFlightsVC: UIViewController {
    
    // MARK: Properties
    
    private var viewModel: DestinationFlightsViewModel!
    private var disposeBag: DisposeBag = DisposeBag()
    private var airportPicker: AirportPickerVC?
    
    weak var scroller: DestinationDetailsVCScrollable?
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UINib(nibName: "CarrierPriceCell", bundle: nil), forCellReuseIdentifier: CarrierPriceCell.reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    private lazy var originView: OriginTextFieldHeaderView = {
        let view = OriginTextFieldHeaderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textField.delegate = self
        view.textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        return view
    }()
    
    private lazy var activitySpinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.activityIndicatorViewStyle = .whiteLarge
        spinner.hidesWhenStopped = true
        spinner.color = UIColor.primaryBlue
        return spinner
    }()
    
    private var rowHeight: CGFloat {
        return 50
    }
    
    private var tableViewHeight: CGFloat {
        return rowHeight * 6
    }
    
    // MARK: View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupTableView()
        setupActivityIndicator()
        bindViewModel()
    }
    
    convenience init(destination: Destination) {
        self.init()
        
        let flightDataService = QPXExpress()
        self.viewModel = DestinationFlightsViewModel(flightDataService: flightDataService,
                                                     airportService: appDelegate.firebaseAirportService!,
                                                     destination: destination)
    }

    // MARK: Setup
    
    private func setupView() {
        view.addSubview(originView)
        NSLayoutConstraint.activate([
            originView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            originView.topAnchor.constraint(equalTo: view.topAnchor),
            originView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setupTableView() {
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: originView.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.heightAnchor.constraint(equalToConstant: tableViewHeight)
        ])
    }
    
    private func setupActivityIndicator() {
        view.addSubview(activitySpinner)
        NSLayoutConstraint.activate([
            activitySpinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activitySpinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func bindViewModel() {
        viewModel.originTextFieldText.bind(to: originView.textField.rx.text).disposed(by: disposeBag)
        viewModel.isSearching.bind(to: activitySpinner.rx.isAnimating).disposed(by: disposeBag)
        viewModel.cheapestFlights.asObservable().subscribe(onNext: { _ in
            self.tableView.reloadData()
        }).disposed(by: disposeBag)
    }
    
    private func presentAirportPicker() {
        guard airportPicker == nil else { return }
        self.airportPicker = AirportPickerVC()
        scroller?.scrollTo(.destinationFlights) {
            guard let airportPicker = self.airportPicker else { return }
            airportPicker.delegate = self
            airportPicker.view.translatesAutoresizingMaskIntoConstraints = false
            airportPicker.airportStatus = .origin
            
            self.add(airportPicker)
            NSLayoutConstraint.activate([
                airportPicker.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 5),
                airportPicker.view.topAnchor.constraint(equalTo: self.tableView.topAnchor, constant: 5),
                airportPicker.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -5),
                airportPicker.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
            ])
        }
    }
    
    private func dismissAirportPicker() {
        guard let airportPicker = airportPicker else { return }
        airportPicker.removeChildViewController()
        self.airportPicker = nil
    }
    
    private func presentSearchVCAndSearchFlights() {
        self.tabBarController?.selectTab(1, animated: true) {
            if let navigationController = self.tabBarController?.selectedViewController as? UINavigationController {
                if let searchVC = navigationController.topViewController as? SearchVC {
                    searchVC.updateUserDefaultsAndSearch()
                }
            }
        }
    }
}

// MARK:- UITableViewDelegate, UITableViewDataSource

extension DestinationFlightsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.deqeueReusableCell(indexPath: indexPath) as CarrierPriceCell
        let flight = viewModel.flight(for: indexPath)
        cell.configureCell(with: flight.departingFlight.carrier, price: flight.saleTotal)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cheapestFlights.value.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        presentSearchVCAndSearchFlights()
    }
}

// MARK:- UITextFieldDelegate

extension DestinationFlightsVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        presentAirportPicker()
        originView.textField.text = ""
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let query = textField.text else { return }
        
        if let airportPicker = self.airportPicker, childViewControllers.contains(airportPicker) {
            airportPicker.searchQuery(didChangeTo: query)
        } else {
            guard query.count > 0 else { return }
            presentAirportPicker()
            airportPicker?.searchQuery(didChangeTo: query)
        }
    }
}

// MARK:- AirportPickerVCDelegate

extension DestinationFlightsVC: AirportPickerVCDelegate {
    func airportPickerVC(_ airportPickerVC: AirportPickerVC, didPickOriginAirport airport: Airport) {
        dismissAirportPicker()
        originView.endEditing()
        UserDefaultsService.instance.origin = airport
        viewModel.updateViewModel(for: airport)
    }
    
    func airportPickerVC(_ airportPickerVC: AirportPickerVC, didPickDestinationAirport airport: Airport) {
        // TODO: Break up delegate protocol and remove this method
    }
    
    func airportPickerVCDismiss(_ airportPickerVC: AirportPickerVC) {
        dismissAirportPicker()
        viewModel.originTextFieldText.accept(viewModel.originTextFieldText.value)
        originView.endEditing()
    }
}

