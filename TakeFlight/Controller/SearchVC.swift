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
        
        // Test Code
//        let request = QPXExpress(adultCount: 1, origin: "MCO", destination: "LAX", date: Date())
//        FlightDataService.instance.retrieveFlightData(forRequest: request) { (flightData) in
//            if let flightData = flightData {
//                self.flights = flightData
//            }
//        }
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
            
        }
    }
    
    // MARK: Convenience
    
    func clearDates() {
        departureDate = nil
        returnDate = nil
    }
    
    private func searchFlights(completion: @escaping ([FlightData]?) -> Void) {
        guard textFieldsContainData() else { return }

    }
    
    private func textFieldsContainData() -> Bool {
        return !(self.originTextField.text == "" &&
                 self.destinationTextField.text == "" &&
                 self.departureDateTextField.text == "" &&
                 self.returnDateTextField.text == "")
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
        guard textField.tag == 3 || textField.tag == 4 else { return true }
        presentDatePicker()
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard textField.tag == 1 || textField.tag == 2 else { return }
        presentAirportPicker(withTag: textField.tag)
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

