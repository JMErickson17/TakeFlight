//
//  ViewController.swift
//  TakeFlight
//
//  Created by Justin Erickson on 10/1/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import UIKit

class SearchVC: UIViewController, FlightConvertable {
    
    // MARK: Properties
    
    @IBOutlet weak var originTextField: UITextField!
    @IBOutlet weak var destinationTextField: UITextField!
    @IBOutlet weak var departureDateTextField: UITextField!
    @IBOutlet weak var returnDateTextField: UITextField!
    @IBOutlet weak var flightDataTableView: UITableView!
    
    private let formatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = Calendar.current.timeZone
        dateFormatter.locale = Calendar.current.locale
        dateFormatter.dateFormat = "MMMM dd"
        return dateFormatter
    }()
    
    var origin: String?
    var destination: String?
    var datesSelected: SelectedState = .none
    
    var departureDate: Date? {
        didSet {
            self.departureDateTextField.text = formatter.string(from: departureDate!)
        }
    }
    
    var returnDate: Date? {
        didSet {
            self.returnDateTextField.text = formatter.string(from: returnDate!)
        }
    }
    
    private var flights = [FlightData]() {
        didSet {
            flightDataTableView.reloadData()
        }
    }
    
    // MARK: View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        setupView()
    }

    // MARK: Setup
    
/*
     Sets up the view, tableView, ect.
 */
    func setupView() {
        
        departureDateTextField.delegate = self
        returnDateTextField.delegate = self
        
        // UITableViewCell Setup
        flightDataTableView.delegate = self
        flightDataTableView.dataSource = self
        
        let roundTripCell = UINib(nibName: Constants.ROUND_TRIP_FLIGHT_DATA_CELL, bundle: nil)
        flightDataTableView.register(roundTripCell, forCellReuseIdentifier: Constants.ROUND_TRIP_FLIGHT_DATA_CELL)
    }
    
    // MARK: Actions
    
    // MARK: Convenience
    
    // MARK: Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DatePickerVC {
            destination.delegate = self
        }
    }
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
        return 5
    }
}

// MARK: - UITextFieldDelegate

extension SearchVC: UITextFieldDelegate {
    
/*
     Present DatePickerVC and prevent the keyboard from showing when the UITextField is tapped.
 */
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        performSegue(withIdentifier: Constants.TO_DATE_PICKER, sender: nil)
        return false
    }
}

