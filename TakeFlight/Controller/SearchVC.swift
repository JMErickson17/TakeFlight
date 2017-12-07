//
//  ViewController.swift
//  TakeFlight
//
//  Created by Justin Erickson on 10/1/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import UIKit

class SearchVC: UIViewController, SearchVCDelegate {
    
    enum FlightSearchError: Error {
        case invalidSearchData
        case invalidRequest
        case invalidReponse
    }
    
    // MARK: Properties
    
    @IBOutlet weak var flightDataTableView: UITableView!
    @IBOutlet weak var departureDateTextField: UITextField!
    @IBOutlet weak var returnDateTextField: UITextField!
    @IBOutlet weak var originTextField: UITextField!
    @IBOutlet weak var destinationTextField: UITextField!
    @IBOutlet weak var roundTripButton: UIButton!
    @IBOutlet weak var oneWayButton: UIButton!
    @IBOutlet weak var searchContainerView: UIView!
    @IBOutlet weak var searchContainerViewTopAnchor: NSLayoutConstraint!
    
    private var user = UserDataService.instance
    private var requestManager = QPXExpress()
    private var airportPickerVC: AirportPickerVC?
    private var datePickerVC: DatePickerVC?
    private var flightDetailsVC: FlightDetailsVC? {
        didSet {
            flightDataTableView.isScrollEnabled = (flightDetailsVC == nil)
        }
    }
    
    weak var searchDelegate: AirportPickerVCDelegate?
    
    var selectedSearchType: SearchType = .oneWay {
        didSet {
            user.searchType = selectedSearchType.rawValue
            updateViewForSearchType(selectedSearchType)
        }
    }
    
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
            originTextField.endEditing(true)
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
            destinationTextField.endEditing(true)
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
    
    private var searchContainerIsVisible: Bool {
        return searchContainerViewTopAnchor.constant == 0
    }
    
    private var flights = [FlightData]() {
        didSet {
            DispatchQueue.main.async {
                self.flightDataTableView.reloadData()
                self.flightDataTableView.isHidden = self.flights.isEmpty
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupTableView()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if originTextField.isEditing {
            let oldOrigin = origin
            origin = oldOrigin
        }
        
        if destinationTextField.isEditing {
            let oldDestination = destination
            destination = oldDestination
        }
        
        if datePickerVC != nil && childViewControllers.contains(datePickerVC!) {
            searchVC(self, shouldDismissDatePicker: true)
        }
    }

    // MARK: Setup
    
    private func setupView() {
        departureDateTextField.delegate = self
        returnDateTextField.delegate = self
        
        originTextField.delegate = self
        destinationTextField.delegate = self
        
        originTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        destinationTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        if let origin = user.origin { self.origin = origin }
        if let destination = user.destination { self.destination = destination }
        if let departureDate = user.departureDate { self.departureDate = departureDate }
        if let returnDate = user.returnDate { self.returnDate = returnDate }
        
        if let searchType = user.searchType {
            self.selectedSearchType = SearchType(rawValue: searchType) ?? .oneWay
        }
    }
    
    private func setupTableView() {
        flightDataTableView.delegate = self
        flightDataTableView.dataSource = self
        
        let oneWayCell = UINib(nibName: Constants.ONE_WAY_FLIGHT_DATA_CELL, bundle: nil)
        flightDataTableView.register(oneWayCell, forCellReuseIdentifier: Constants.ONE_WAY_FLIGHT_DATA_CELL)
        
        let roundTripCell = UINib(nibName: Constants.ROUND_TRIP_FLIGHT_DATA_CELL, bundle: nil)
        flightDataTableView.register(roundTripCell, forCellReuseIdentifier: Constants.ROUND_TRIP_FLIGHT_DATA_CELL)
        
        flightDataTableView.isHidden = flights.isEmpty
    }
    
    // MARK: Actions
    
    @IBAction func searchButtonTapped(_ sender: UIButton) {
        searchFlightsWithUserDefaults { [weak self] (flightData, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            if let flightData = flightData {
                self?.flights = flightData
                print(flightData)
            }
        }
    }
    
    @IBAction func roundTripButtonTapped(_ sender: UIButton) {
        selectedSearchType = .roundTrip
    }
    
    @IBAction func oneWayButtonTapped(_ sender: UIButton) {
        selectedSearchType = .oneWay
    }
    
    // MARK: Delegate Methods
    
    func searchVC(_ searchVC: SearchVC, shouldClearLocations: Bool) {
        if shouldClearLocations {
            origin = nil
            destination = nil
        }
    }
    
    func searchVC(_ searchVC: SearchVC, shouldClearDates: Bool) {
        if shouldClearDates {
            departureDate = nil
            returnDate = nil
        }
    }
    
    private func updateViewForSearchType(_ searchType: SearchType) {
        switch searchType {
        case .oneWay:
            oneWayButton.layer.opacity = 1
            roundTripButton.layer.opacity = 0.5
        case.roundTrip:
            oneWayButton.layer.opacity = 0.5
            roundTripButton.layer.opacity = 1
        }
    }
    
    // MARK: Convenience
    
    private func searchFlightsWithUserDefaults(completion: @escaping ([FlightData]?, Error?) -> Void) {
        guard searchDataIsValid() else { return completion(nil, FlightSearchError.invalidSearchData) }
        
        let userOptions = [QPXExpressOptions]()
        let request = requestManager.makeQPXRequest(adultCount: 1, from: user.origin!, to: user.destination!, departing: user.departureDate!, returning: user.returnDate, withOptions: userOptions)
        
        print(request)
        
        requestManager.fetch(qpxRequest: request) { (flightData, error) in
            guard error == nil else { return completion(nil, error!) }
            if let flightData = flightData {
//                print(flightData)
                completion(flightData, nil)
            }
        }
    }
    
    private func searchDataIsValid() -> Bool {
        if let userOrigin = user.origin, let userDestination = user.destination,
            let userDepartureDate = user.departureDate {
            return (originTextField.text == userOrigin.searchRepresentation) &&
                (destinationTextField.text == userDestination.searchRepresentation) &&
                (departureDateTextField.text == formatter.string(from: userDepartureDate)) &&
                (selectedSearchType == .roundTrip ? returnDateTextField.text == formatter.string(from: user.returnDate ?? Date()) : true)
        }
        return false
    }
    
    private func presentAirportPicker(withTag tag: Int, completion: (() -> Void)? = nil) {
        guard airportPickerVC == nil else { return }
        
        airportPickerVC = AirportPickerVC()
        airportPickerVC?.delegate = self
        airportPickerVC!.currentTextFieldTag = tag
        searchDelegate = airportPickerVC
        
        addChildViewController(airportPickerVC!)
        airportPickerVC!.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(airportPickerVC!.view)
        
        NSLayoutConstraint.activate([
            airportPickerVC!.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            airportPickerVC!.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            airportPickerVC!.view.topAnchor.constraint(equalTo: originTextField.bottomAnchor, constant: 5),
            airportPickerVC!.view.heightAnchor.constraint(equalToConstant: 250)
            ])
        
        airportPickerVC!.didMove(toParentViewController: self)
        
        if let completion = completion {
            completion()
        }
    }
    
    func searchVC(_ searchVC: SearchVC, shouldDismissAirportPicker: Bool) {
        if shouldDismissAirportPicker {
            guard airportPickerVC != nil else { return }
            guard childViewControllers.contains(airportPickerVC!) else { return }
            airportPickerVC!.willMove(toParentViewController: nil)
            airportPickerVC!.view.removeFromSuperview()
            airportPickerVC!.removeFromParentViewController()
            airportPickerVC = nil
        }
    }
    
    private func presentDatePicker(completion: (() -> Void)? = nil) {
        guard datePickerVC == nil else { return }
        
        datePickerVC = DatePickerVC()
        datePickerVC?.delegate = self
        
        addChildViewController(datePickerVC!)
        datePickerVC!.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(datePickerVC!.view)
        
        NSLayoutConstraint.activate([
            datePickerVC!.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            datePickerVC!.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            datePickerVC!.view.topAnchor.constraint(equalTo: departureDateTextField.bottomAnchor, constant: 10),
            datePickerVC!.view.heightAnchor.constraint(equalToConstant: 400)
        ])
        
        datePickerVC!.didMove(toParentViewController: self)
        
        if let completion = completion {
            completion()
        }
    }
    
    func searchVC(_ searchVC: SearchVC, shouldDismissDatePicker: Bool) {
        if shouldDismissDatePicker {
            guard datePickerVC != nil else { return }
            guard childViewControllers.contains(datePickerVC!) else { return }
            datePickerVC!.willMove(toParentViewController: nil)
            datePickerVC!.view.removeFromSuperview()
            datePickerVC!.removeFromParentViewController()
            datePickerVC = nil
        }
    }
    
    private func presentFlightDetails(forCellAt indexPath: IndexPath, completion: (() -> Void)? = nil) {
        guard flightDetailsVC == nil else { return }
        guard let cell = flightDataTableView.cellForRow(at: indexPath) else { return }
        
        flightDetailsVC = FlightDetailsVC()
        // Setup Code
        
        addChildViewController(flightDetailsVC!)
        flightDetailsVC!.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(flightDetailsVC!.view)
        
        NSLayoutConstraint.activate([
            flightDetailsVC!.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            flightDetailsVC!.view.topAnchor.constraint(equalTo: flightDataTableView.topAnchor, constant: cell.frame.height),
            flightDetailsVC!.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            flightDetailsVC!.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        if let completion = completion {
            completion()
        }
    }
    
    func searchVC(_ searchVC: SearchVC, shouldDismissFlightDetails: Bool) {
        if shouldDismissFlightDetails {
            guard flightDetailsVC != nil else { return }
            guard childViewControllers.contains(flightDetailsVC!) else { return }
            flightDetailsVC!.willMove(toParentViewController: nil)
            flightDetailsVC!.view.removeFromSuperview()
            flightDetailsVC!.removeFromParentViewController()
            flightDetailsVC = nil
        }
    }
    
    private func hideSearchContainerView(withDuration duration: TimeInterval = 1.0, completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: duration, animations: { [weak self] in
            self?.searchContainerViewTopAnchor.constant = -(self?.searchContainerView.frame.height ?? 0)
            self?.view.layoutIfNeeded()
        }) { finished in
            if finished, let completion = completion {
                completion()
            }
        }
    }
    
    private func showSearchContainerView(withDuration duration: TimeInterval = 1.0, completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: duration, animations: { [weak self] in
            self?.searchContainerViewTopAnchor.constant = 0
            self?.view.layoutIfNeeded()
        }) { finished in
            if finished, let completion = completion {
                completion()
            }
        }
    }
}

// MARK: - UITableView

extension SearchVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //return tableView.dequeueReusableCell(withIdentifier: Constants.ONE_WAY_FLIGHT_DATA_CELL) as! OneWayFlightDataCell
        if selectedSearchType == .oneWay {
            if let cell = tableView.dequeueReusableCell(withIdentifier: Constants.ONE_WAY_FLIGHT_DATA_CELL, for: indexPath) as? OneWayFlightDataCell {
                let flightData = flights[indexPath.row]
                cell.configureCell(withFlightData: flightData)
                return cell
            }
        } else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: Constants.ROUND_TRIP_FLIGHT_DATA_CELL, for: indexPath) as? RoundTripFlightDataCell {
                let flightData = flights[indexPath.row]
                cell.configureCell(withFlightData: flightData)
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        guard let cell = tableView.cellForRow(at: indexPath) else { return nil }

        if cell.isSelected {
            tableView.deselectRow(at: indexPath, animated: true)
            showSearchContainerView()
            searchVC(self, shouldDismissFlightDetails: true)
            tableView.reloadData()
            return nil
        }
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath) == tableView.topCell {
            hideSearchContainerView {
                self.presentFlightDetails(forCellAt: indexPath, completion: nil)
            }
        } else {
            hideSearchContainerView()
            tableView.scrollToRow(at: indexPath, at: .top, withDuration: 1.0, completion: {
                self.presentFlightDetails(forCellAt: indexPath, completion: nil)
            })
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        showSearchContainerView()
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if selectedSearchType == .oneWay {
            return 120
        } else {
            return 175
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flights.count
    }
}

// MARK: - UITextFieldDelegate

extension SearchVC: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        guard textField.tag == 3 || textField.tag == 4 else { return true }
        presentDatePicker()
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //TODO: Update origin and destination based on textField.text
        if textField.text == "" {
            handleClearTextField(textField)
        }
        searchVC(self, shouldDismissAirportPicker: true)
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        handleClearTextField(textField)
        return true
    }
    
    func handleClearTextField(_ textField: UITextField) {
        switch textField.tag {
        case 1:
            self.origin = nil
        case 2:
            self.destination = nil
        default: break
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let query = textField.text else { return }
        
        if airportPickerVC != nil && childViewControllers.contains(airportPickerVC!) {
            if query.count > 1 {
                searchDelegate?.airportPickerVC(searchDelegate as! AirportPickerVC, searchQueryDidChange: true, withQuery: query)
            } else {
                searchVC(self, shouldDismissAirportPicker: true)
            }
        } else {
            guard query.count > 1 else { return }
            presentAirportPicker(withTag: textField.tag, completion: {
                self.searchDelegate?.airportPickerVC(self.searchDelegate as! AirportPickerVC, searchQueryDidChange: true, withQuery: query)
            })
        }
    }
}
