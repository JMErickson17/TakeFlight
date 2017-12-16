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
    
    weak var searchDelegate: AirportPickerVCDelegate?
    
    private var user = UserDataService.instance
    private var requestManager = QPXExpress()
    private var airportPickerVC: AirportPickerVC?
    private var datePickerVC: DatePickerVC?
    private var takeoffLoadingView: TakeoffLoadingView?
    private var flightDetailsVC: FlightDetailsVC?
    
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
    
    private var flights = [FlightData]() {
        didSet {
            DispatchQueue.main.async {
                if self.flights.isEmpty && !self.flightDataTableView.isHidden {
                    self.flightDataTableView.isHidden = true
                    self.searchVC(self, flightDataTableView: self.flightDataTableView, didHide: true)
                } else if !self.flights.isEmpty && self.flightDataTableView.isHidden {
                    self.flightDataTableView.isHidden = false
                    self.searchVC(self, flightDataTableView: self.flightDataTableView, didShow: true)
                }
                self.flightDataTableView.reloadData()
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = "Search Flights"
        let backButton = UIBarButtonItem()
        backButton.title = "Back"
        navigationItem.backBarButtonItem = backButton
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
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.barStyle = .black
        
        originTextField.delegate = self
        destinationTextField.delegate = self
        
        departureDateTextField.delegate = self
        returnDateTextField.delegate = self
        
        
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
    
    func searchVC(_ searchVC: SearchVC, flightDataTableView tableView: UITableView, didHide: Bool) {
        if didHide && takeoffLoadingView == nil {
            presentTakeoffLoadingView()
        }
    }
    
    func searchVC(_ searchVC: SearchVC, flightDataTableView tableView: UITableView, didShow: Bool) {
        if didShow && takeoffLoadingView != nil {
            dismissTakeoffLoadingView()
        }
    }
    
    // MARK: Convenience
    
    private func updateViewForSearchType(_ searchType: SearchType) {
        switch searchType {
        case .oneWay:
            oneWayButton.layer.opacity = 1
            roundTripButton.layer.opacity = 0.5
            returnDate = nil
            returnDateTextField.placeholder = "One Way"
        case.roundTrip:
            oneWayButton.layer.opacity = 0.5
            roundTripButton.layer.opacity = 1
            returnDateTextField.placeholder = "Return Date"
        }
        flights.removeAll()
        
        searchFlightsWithUserDefaults(completion: handleNewSearchResults(withFlightData:error:))
        
    }
    
    private func searchFlightsWithUserDefaults(completion: @escaping ([FlightData]?, Error?) -> Void) {
        guard searchDataIsValid() else { return completion(nil, FlightSearchError.invalidSearchData) }
        var returnDate: Date?
        if selectedSearchType == .roundTrip, let userReturnDate = user.returnDate {
            returnDate = userReturnDate
        }
        
        let userOptions = [QPXExpressOptions]()
        let request = requestManager.makeQPXRequest(adultCount: 1, from: user.origin!, to: user.destination!, departing: user.departureDate!, returning: returnDate, withOptions: userOptions)
        
        requestManager.fetch(qpxRequest: request) { (flightData, error) in
            guard error == nil else { return completion(nil, error!) }
            if let flightData = flightData {
                completion(flightData, nil)
            }
        }
    }
    
    // TODO: Fix memory cycle possibility
    private func handleNewSearchResults(withFlightData flightData: [FlightData]?, error: Error?) {
        guard error == nil else {
            print(error!.localizedDescription)
            return
        }
        
        if let flightData = flightData {
            self.flights.removeAll()
            self.flights = flightData
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
        
        completion?()
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
        
        completion?()
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
        let data = flights[indexPath.row]
        let flightDetailsVC = FlightDetailsVC()
        flightDetailsVC.flightData = data
        navigationController?.pushViewController(flightDetailsVC, animated: true)
    }
    
    private func presentTakeoffLoadingView() {
        guard takeoffLoadingView == nil else { return }
        
        takeoffLoadingView = TakeoffLoadingView(frame: CGRect.zero)
        takeoffLoadingView?.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(takeoffLoadingView!)
        NSLayoutConstraint.activate([
            takeoffLoadingView!.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            takeoffLoadingView!.topAnchor.constraint(equalTo: searchContainerView.bottomAnchor),
            takeoffLoadingView!.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            takeoffLoadingView!.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        view.layoutSubviews()
    }
    
    private func dismissTakeoffLoadingView() {
        guard takeoffLoadingView != nil else { return }
        
        takeoffLoadingView?.removeFromSuperview()
        takeoffLoadingView = nil
        view.layoutIfNeeded()
    }
}

// MARK: - UITableView

extension SearchVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let flightData = flights[indexPath.row]
        
        if flightData.isRoundTrip {
            if let cell = tableView.dequeueReusableCell(withIdentifier: Constants.ROUND_TRIP_FLIGHT_DATA_CELL, for: indexPath) as? RoundTripFlightDataCell {
                cell.configureCell(withFlightData: flightData)
                return cell
            }
        } else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: Constants.ONE_WAY_FLIGHT_DATA_CELL, for: indexPath) as? OneWayFlightDataCell {
                cell.configureCell(withFlightData: flightData)
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presentFlightDetails(forCellAt: indexPath)
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
            guard query.count >= 1 else { return }
            presentAirportPicker(withTag: textField.tag, completion: {
                self.searchDelegate?.airportPickerVC(self.searchDelegate as! AirportPickerVC, searchQueryDidChange: true, withQuery: query)
            })
        }
    }
}

// MARK: SearchVC+TakeoffLoadingViewDelegate

extension SearchVC: TakeoffLoadingViewDelegate {
    func takeoffLoadingView(_ takeoffLoadingView: TakeoffLoadingView, runwayWillAnimateOffScreen: Bool) {
        
    }
}
