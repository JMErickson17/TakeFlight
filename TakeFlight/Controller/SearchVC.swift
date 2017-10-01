//
//  ViewController.swift
//  TakeFlight
//
//  Created by Justin Erickson on 10/1/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import UIKit

class SearchVC: UIViewController {
    
    // MARK: Properties
    
    @IBOutlet weak var fromLocationTextField: UITextField!
    @IBOutlet weak var toLocationTextField: UITextField!
    @IBOutlet weak var departureDateTextField: UITextField!
    @IBOutlet weak var returnDateTextField: UITextField!
    @IBOutlet weak var flightDataTableView: UITableView!
    
    // MARK: View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        flightDataTableView.delegate = self
        flightDataTableView.dataSource = self
        
        setupView()
        
        let data = QPXExpress(adultCount: 1, origin: "MCO", destination: "LAX", date: Date.distantPast)
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            let json = try encoder.encode(data)
            print(String(data: json, encoding: .utf8)!)
        } catch {

        }
    }

    // MARK: Setup
    
/**
     Sets up the view, tableView, ect.
 */
    func setupView() {
        
        // UITableViewCell Setup
        let roundTripCell = UINib(nibName: Constants.ROUND_TRIP_FLIGHT_DATA_CELL, bundle: nil)
        flightDataTableView.register(roundTripCell, forCellReuseIdentifier: Constants.ROUND_TRIP_FLIGHT_DATA_CELL)
    }
    
    // MARK: Actions
    
    // MARK: Convenience
    
}

// MARK: - UITableView

extension SearchVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Constants.ROUND_TRIP_FLIGHT_DATA_CELL, for: indexPath) as? RoundTripFlightDataCell {
            cell.configureCell()
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // TODO: Make size dynamic depending on type of cell
        return 175
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
}

