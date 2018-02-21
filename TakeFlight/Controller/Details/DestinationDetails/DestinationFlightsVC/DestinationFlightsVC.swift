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
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UINib(nibName: "CarrierPriceCell", bundle: nil), forCellReuseIdentifier: CarrierPriceCell.reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    private let originView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let originTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.cornerRadius = 5
        return textField
    }()
    
    // MARK: View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupTableView()
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
        originView.addSubview(originTextField)
        NSLayoutConstraint.activate([
            originTextField.leadingAnchor.constraint(equalTo: originView.leadingAnchor, constant: 16),
            originTextField.topAnchor.constraint(equalTo: originView.topAnchor, constant: 16),
            originTextField.trailingAnchor.constraint(equalTo: originView.trailingAnchor, constant: -16),
            originTextField.bottomAnchor.constraint(equalTo: originView.bottomAnchor, constant: -16),
            originTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
        
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
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func bindViewModel() {
        viewModel.originTextFieldText.bind(to: originTextField.rx.text).disposed(by: disposeBag)
        viewModel.cheapestFlights.asObservable().subscribe(onNext: { _ in
            self.tableView.reloadData()
        }).disposed(by: disposeBag)
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
}
