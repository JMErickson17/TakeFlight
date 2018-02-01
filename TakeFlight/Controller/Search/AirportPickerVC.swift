//
//  AirportPickerVC.swift
//  TakeFlight
//
//  Created by Justin Erickson on 10/27/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import UIKit
import Firebase

class AirportPickerVC: UIViewController {
    
    // MARK: Properties
    
    weak var delegate: AirportPickerVCDelegate?
    
    var currentTextFieldTag: Int?
    
    private var maxSearchResults = 20
    private var airportService: AirportService!
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 60
        tableView.register(AirportPickerCell.self, forCellReuseIdentifier: Constants.AIRPORT_PICKER_CELL)
        return tableView
    }()
    
    private lazy var tooltipView: TooltipView = {
        let view = TooltipView()
        view.tooltipLocation = (currentTextFieldTag == 1 ? 0.25 : 0.75)
        view.isOpaque = false
        view.borderRadius = 5
        return view
    }()
    
    private lazy var dismissButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(dismissAirportPicker), for: .touchUpInside)
        button.setImage(#imageLiteral(resourceName: "CloseButton"), for: .normal)
        button.tintColor = .primaryBlue
        return button
    }()
    
    private var filteredAirports = [Airport]() {
        didSet {
            tableView.reloadData()
        }
    }

    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.airportService = appDelegate.firebaseAirportService!
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setupView()
    }

    // MARK: Setup
    
    func setupView() {
        tooltipView.frame = view.bounds
        view.addSubview(tooltipView)
        
        tableView.frame = CGRect(x: 5, y: 5, width: tooltipView.bounds.width - 10, height: tooltipView.bounds.height - 10)
        tooltipView.addSubview(tableView)
        
        view.addSubview(dismissButton)
        NSLayoutConstraint.activate([
            dismissButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 4),
            dismissButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -4),
            dismissButton.heightAnchor.constraint(equalToConstant: 20),
            dismissButton.widthAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    func searchQuery(didChangeTo query: String) {
        let groupedDictionary = Dictionary(grouping: airportService.airports(containing: query)) { $0.country == "US" }
        filteredAirports = groupedDictionary.map { $0.value }.flatMap { $0 }.reversed()
    }
    
    @objc func dismissAirportPicker() {
        delegate?.airportPickerVCDismiss(self)
    }
}

// MARK: - UITableView

extension AirportPickerVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Constants.AIRPORT_PICKER_CELL, for: indexPath) as? AirportPickerCell {
            let airport = filteredAirports[indexPath.row]
            cell.configureCell(name: airport.searchRepresentation, location: airport.locationString)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let currentTextFieldTag = currentTextFieldTag else { return }
        let airport = filteredAirports[indexPath.row]
        
        switch currentTextFieldTag {
        case 1:
            delegate?.airportPickerVC(self, didPickOriginAirport: airport)
        case 2:
            delegate?.airportPickerVC(self, didPickDestinationAirport: airport)
        default:
            return
        }
        
        delegate?.airportPickerVCDismiss(self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredAirports.count > maxSearchResults ? maxSearchResults : filteredAirports.count
    }
}
