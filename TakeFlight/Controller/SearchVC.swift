//
//  ViewController.swift
//  TakeFlight
//
//  Created by Justin Erickson on 10/1/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import UIKit

class SearchVC: UIViewController, SearchVCDelegate {
    
    // MARK: Properties
    
    @IBOutlet weak var flightDataTableView: UITableView!
    @IBOutlet weak var departureDateTextField: UITextField!
    @IBOutlet weak var returnDateTextField: UITextField!
    @IBOutlet weak var originTextField: UITextField!
    @IBOutlet weak var destinationTextField: UITextField!
    
    private var user = UserDataService.instance
    var searchDelegate: AirportPickerVCDelegate?
    
    var datesSelected: SelectedState {
        if departureDate == nil && returnDate == nil {
            return .none
        } else if departureDate != nil && returnDate == nil {
            return .departure
        } else if departureDate != nil && returnDate != nil {
            return .departureAndReturn
        }
        departureDate = nil
        returnDate = nil
        return .none
    }
    
    var origin: Airport? {
        didSet {
            if let origin = origin {
                user.origin = origin
                originTextField.text = origin.searchRepresentation
            } else {
                originTextField.text = ""
                user.origin = nil
            }
        }
    }
    
    var destination: Airport? {
        didSet {
            if let destination = destination {
                user.destination = destination
                destinationTextField.text = destination.searchRepresentation
            } else {
                destinationTextField.text = ""
                user.destination = nil
            }
        }
    }
    
    var departureDate: Date? {
        didSet {
            if let departureDate = departureDate {
                user.departureDate = departureDate
                departureDateTextField.text = formatter.string(from: departureDate)
            } else {
                departureDateTextField.text = ""
                user.departureDate = nil
            }
        }
    }
    
    var returnDate: Date? {
        didSet {
            if let returnDate = returnDate {
                user.returnDate = returnDate
                returnDateTextField.text = formatter.string(from: returnDate)
            } else {
                returnDateTextField.text = ""
                user.returnDate = nil
            }
        }
    }
    
    private let formatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = Calendar.current.timeZone
        dateFormatter.locale = Calendar.current.locale
        dateFormatter.dateFormat = "MMMM dd"
        return dateFormatter
    }()
    
    private var flights = [FlightData]() {
        didSet {
            flightDataTableView.reloadData()
        }
    }
    
    // MARK: View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupTableView()
        
    }

    // MARK: Setup
    
    private func setupView() {
        departureDateTextField.delegate = self
        returnDateTextField.delegate = self
        
        originTextField.delegate = self
        destinationTextField.delegate = self
        
        originTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        destinationTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        if let origin = user.origin {
            self.origin = origin
        }
        
        if let destination = user.destination {
            self.destination = destination
        }
        
        if let departureDate = user.departureDate {
            self.departureDate = departureDate
        }
        
        if let returnDate = user.returnDate {
            self.returnDate = returnDate
        }
    }
    
    private func setupTableView() {
        flightDataTableView.delegate = self
        flightDataTableView.dataSource = self
        
        let roundTripCell = UINib(nibName: Constants.ROUND_TRIP_FLIGHT_DATA_CELL, bundle: nil)
        flightDataTableView.register(roundTripCell, forCellReuseIdentifier: Constants.ROUND_TRIP_FLIGHT_DATA_CELL)
    }
    
    // MARK: Actions
    
    @IBAction func searchButtonTapped(_ sender: Any) {
        searchFlights { (flightData) in
            if let flights = flightData {
                self.flights = flights
            }
        }
    }
    
    // MARK: Convenience
    
    func clearLocations() {
        origin = nil
        destination = nil
    }
    
    func clearDates() {
        departureDate = nil
        returnDate = nil
    }
    
    private func searchFlights(completion: @escaping ([FlightData]?) -> Void) {
        guard searchDataIsValid() else { return completion(nil) }
        let request = QPXExpress(adultCount: 1, origin: origin!.iata, destination: destination!.iata, date: departureDate!)
        
        FlightDataService.instance.retrieveFlightData(forRequest: request) { (flightData) in
            completion(flightData)
        }
    }
    
    private func searchDataIsValid() -> Bool {
        guard origin != nil else { return false }
        guard destination != nil else { return false }
        guard departureDate != nil else { return false }
        guard returnDate != nil else { return false }
        
        return true
    }
    
    private func presentDatePicker(completion: (() -> Void)? = nil) {
        if let datePickerVC = storyboard?.instantiateViewController(withIdentifier: Constants.DATE_PICKER_VC) as? DatePickerVC {
            datePickerVC.delegate = self
            datePickerVC.modalPresentationStyle = .overCurrentContext
            present(datePickerVC, animated: true, completion: completion)
        }
    }
    
    private func presentAirportPicker(withTag tag: Int, completion: (() -> Void)? = nil) {
        let airportPickerVC = AirportPickerVC(nibName: Constants.AIRPORT_PICKER_VC, bundle: nil)
        airportPickerVC.delegate = self
        airportPickerVC.currentTextFieldTag = tag
        searchDelegate = airportPickerVC
        airportPickerVC.modalPresentationStyle = .overCurrentContext
        present(airportPickerVC, animated: false, completion: completion)
    }
}

// MARK: - UITableView

extension SearchVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Constants.ROUND_TRIP_FLIGHT_DATA_CELL, for: indexPath) as? RoundTripFlightDataCell {
            let flight = flights[indexPath.row]
            cell.configureCell(withFlightData: flight)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // TODO: Make size dynamic depending on type of cell
        return 175
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flights.count
    }
}

// MARK: - UITextFieldDelegate

extension SearchVC: UITextFieldDelegate {
    
/*
     Present DatePickerVC and prevent the keyboard from showing when the UITextField is tapped.
 */
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        guard textField.tag == 3 || textField.tag == 4 else { return true }
        presentDatePicker()
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard textField.tag == 1 || textField.tag == 2 else { return }
        presentAirportPicker(withTag: textField.tag)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard textField.text == "" else { return }
        
        switch textField.tag {
        case 1:
            self.origin = nil
        case 2:
            self.destination = nil
        default:
            break
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let query = textField.text else { return }
        
        if let topViewController = UIApplication.topViewController() {
            if topViewController.isKind(of: AirportPickerVC.self) {
                searchDelegate?.searchQueryDidChange(query: query)
            } else {
                presentAirportPicker(withTag: textField.tag, completion: {
                    self.searchDelegate?.searchQueryDidChange(query: query)
                    textField.becomeFirstResponder()
                })
            }
        }
    }
}
