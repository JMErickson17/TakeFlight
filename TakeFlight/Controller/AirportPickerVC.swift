//
//  AirportPickerVC.swift
//  TakeFlight
//
//  Created by Justin Erickson on 10/27/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import UIKit

class AirportPickerVC: UIViewController {
    
    // MARK: Properties
    
    var delegate: SearchVCDelegate?
    var currentTextFieldTag: Int?
    
    private var tableView: UITableView!
    private var maxSearchResults = 20
    
    private var filteredAirports = [Airport]() {
        didSet {
            tableView.reloadData()
        }
    }

    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupTableView()
    }

    // MARK: Setup
    
    func setupView() {
        
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 5
        view.layer.shadowOpacity = 0.7
        view.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        view.clipsToBounds = true
    }
    
    func setupTableView() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.frame
        tableView.rowHeight = 60
        
        tableView.register(AirportPickerCell.self, forCellReuseIdentifier: Constants.AIRPORT_PICKER_CELL)
        
        view.addSubview(tableView)
    }
    
}

// MARK: - UITableView

extension AirportPickerVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Constants.AIRPORT_PICKER_CELL, for: indexPath) as? AirportPickerCell {
            let airport = filteredAirports[indexPath.row]
            cell.configureCell(name: airport.searchRepresentation, location: airport.cityAndCountry)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let currentTextFieldTag = currentTextFieldTag else { return }
        let airport = filteredAirports[indexPath.row]
        
        switch currentTextFieldTag {
        case 1:
            delegate?.origin = airport
        case 2:
            delegate?.destination = airport
        default:
            return
        }
        delegate?.dismissAirportPicker()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredAirports.count > maxSearchResults ? maxSearchResults : filteredAirports.count
    }
}

// MARK: UISearchController

extension AirportPickerVC: AirportPickerVCDelegate {
    func searchQueryDidChange(query: String) {
        filteredAirports = FlightDataService.instance.searchAirports(forQuery: query)
    }
}
