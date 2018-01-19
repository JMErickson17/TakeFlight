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
    
    weak var delegate: AirportPickerVCDelegate?
    
    var currentTextFieldTag: Int?
    
    private var maxSearchResults = 20
    
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
    
    private var filteredAirports = [Airport]() {
        didSet {
            tableView.reloadData()
        }
    }

    // MARK: View Life Cycle
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setup()
    }

    // MARK: Setup
    
    func setup() {
        tooltipView.frame = view.bounds
        view.addSubview(tooltipView)
        
        tableView.frame = CGRect(x: 5, y: 5, width: tooltipView.bounds.width - 10, height: tooltipView.bounds.height - 10)
        tooltipView.addSubview(tableView)
    }
    
    func searchQuery(didChangeTo query: String) {
        filteredAirports = OldAirportService.instance.searchAirports(forQuery: query)
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
            delegate?.airportPickerVC(self, didPickOriginAirport: airport)
        case 2:
            delegate?.airportPickerVC(self, didPickDestinationAirport: airport)
        default:
            return
        }
        
        delegate?.airportPickerVC(self, shouldDismiss: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredAirports.count > maxSearchResults ? maxSearchResults : filteredAirports.count
    }
}
