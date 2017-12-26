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
        case invalidUserSearchRequest
    }
    
    enum SearchState {
        case noResults
        case searching
        case someResults
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
    
    private lazy var userDataService = UserDataService.instance
    
    private var requestManager = QPXExpress()
    private var airportPickerVC: AirportPickerVC?
    private var datePickerVC: DatePickerVC?
    
    var selectedSearchType: SearchType = .oneWay {
        didSet {
            userDataService.searchType = selectedSearchType.rawValue
            configureViewForSearchType(selectedSearchType)
        }
    }
    
    var currentSearchState: SearchState? {
        didSet {
            if let currentSearchState = currentSearchState {
                configureViewForSearchState(currentSearchState)
            }
        }
    }
    
    var shouldSearch: Bool {
        return airportPickerVC == nil && datePickerVC == nil && self.view.window != nil && flights.isEmpty
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
                userDataService.origin = origin
                originTextField.text = origin.searchRepresentation
            } else {
                originTextField.text = ""
                userDataService.origin = nil
            }
            originTextField.endEditing(true)
        }
    }
    
    var destination: Airport? {
        didSet {
            if let destination = destination {
                userDataService.destination = destination
                destinationTextField.text = destination.searchRepresentation
            } else {
                destinationTextField.text = ""
                userDataService.destination = nil
            }
            destinationTextField.endEditing(true)
        }
    }
    
    var departureDate: Date? {
        didSet {
            if let departureDate = departureDate {
                userDataService.departureDate = departureDate
                departureDateTextField.text = formatter.string(from: departureDate)
            } else {
                departureDateTextField.text = ""
                userDataService.departureDate = nil
            }
            
        }
    }
    
    var returnDate: Date? {
        didSet {
            if let returnDate = returnDate {
                userDataService.returnDate = returnDate
                returnDateTextField.text = formatter.string(from: returnDate)
            } else {
                returnDateTextField.text = ""
                userDataService.returnDate = nil
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
                self.flightDataTableView.reloadData()
            }
        }
    }
    
    private lazy var emptyFlightsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 0
        label.isHidden = true
        label.text = "Looks like were missing some information needed for this search."
        return label
    }()
    
    private lazy var activitySpinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.activityIndicatorViewStyle = .whiteLarge
        spinner.hidesWhenStopped = true
        spinner.color = UIColor(named: "PrimaryBlue")
        return spinner
    }()
    
    // MARK: View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let backButton = UIBarButtonItem()
        backButton.title = "Back"
        navigationItem.backBarButtonItem = backButton
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        searchFlightsWithUserDefaults()
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
        
        if let origin = userDataService.origin { self.origin = origin }
        if let destination = userDataService.destination { self.destination = destination }
        if let departureDate = userDataService.departureDate { self.departureDate = departureDate }
        if let returnDate = userDataService.returnDate { self.returnDate = returnDate }
        
        if let searchType = userDataService.searchType {
            self.selectedSearchType = SearchType(rawValue: searchType) ?? .oneWay
        }
        
        view.addSubview(activitySpinner)
        NSLayoutConstraint.activate([
            activitySpinner.centerXAnchor.constraint(equalTo: flightDataTableView.centerXAnchor),
            activitySpinner.centerYAnchor.constraint(equalTo: flightDataTableView.centerYAnchor)
        ])
        
        self.view.addSubview(emptyFlightsLabel)
        NSLayoutConstraint.activate([
            emptyFlightsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyFlightsLabel.centerYAnchor.constraint(equalTo: flightDataTableView.centerYAnchor),
            emptyFlightsLabel.widthAnchor.constraint(lessThanOrEqualTo: flightDataTableView.widthAnchor, multiplier: 0.90)
        ])
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
        searchFlightsWithUserDefaults()
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
    
    // MARK: View Configuration
    
    private func configureViewForSearchType(_ searchType: SearchType) {
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
        searchFlightsWithUserDefaults()
    }
    
    private func configureViewForSearchState(_ searchState: SearchState) {
        switch searchState {
        case .noResults:
            showEmptyFlightsLabel()
            activitySpinner.stopAnimating()
        case .searching:
            flights.removeAll()
            hideEmptyFlightsLabel()
            activitySpinner.startAnimating()
        case .someResults:
            hideEmptyFlightsLabel()
            activitySpinner.stopAnimating()
        }
    }
    
    private func showEmptyFlightsLabel() {
        DispatchQueue.main.async {
            self.emptyFlightsLabel.isHidden = false
        }
    }
    
    private func hideEmptyFlightsLabel() {
        DispatchQueue.main.async {
            self.emptyFlightsLabel.isHidden = true
        }
    }
    
    // MARK: Search Methods
    
    private func searchFlightsWithUserDefaults() {
        guard shouldSearch else { return }
        guard canSearchWithUserDefaults() else { return handleSearchError(FlightSearchError.invalidSearchData) }
        if let userSearchRequest = makeUserSearchRequestFromUserDefaults() {
            currentSearchState = .searching
            
            let qpxRequest = requestManager.makeQPXRequest(adultCount: 1,
                                                           from: userSearchRequest.origin,
                                                           to: userSearchRequest.destination,
                                                           departing: userSearchRequest.departureDate,
                                                           returning: userSearchRequest.returnDate)
            
            requestManager.fetch(qpxRequest: qpxRequest, completion: { [weak self] (flightData, error) in
                if let error = error, let searchVC = self { return searchVC.handleSearchError(error) }
                if let flightData = flightData {
                    self?.saveToCurrentUser(userSearchRequest: userSearchRequest)
                    self?.handleNewFlightData(flightData)
                } else {
                    self?.handleSearchError(FlightSearchError.invalidReponse)
                }
            })
        }
    }
    
    private func handleNewFlightData(_ flightData: [FlightData]) {
        self.flights = flightData
        if flights.count == 0 {
            currentSearchState = .noResults
        } else {
            currentSearchState = .someResults
        }
    }
    
    private func handleSearchError(_ error: Error) {
        self.flights.removeAll()
        currentSearchState = .noResults
        print(error)
    }
    
    private func canSearchWithUserDefaults() -> Bool {
        if let userOrigin = userDataService.origin, let userDestination = userDataService.destination,
            let userDepartureDate = userDataService.departureDate {
            guard originTextField.text == userOrigin.searchRepresentation else { return false }
            guard destinationTextField.text == userDestination.searchRepresentation else { return false }
            guard departureDateTextField.text == formatter.string(from: userDepartureDate) else { return false }
            
            if selectedSearchType == .roundTrip {
                guard let userReturnDate = userDataService.returnDate else { return false }
                guard returnDateTextField.text == formatter.string(from: userReturnDate) else { return false }
            }
            return true
        }
        return false
    }
    
    private func makeUserSearchRequestFromUserDefaults() -> UserSearchRequest? {
        guard canSearchWithUserDefaults() else { return nil }
        return UserSearchRequest(timeStamp: Date(),
                                 origin: userDataService.origin!,
                                 destination: userDataService.destination!,
                                 departureDate: userDataService.departureDate!,
                                 returnDate: userDataService.returnDate)
    }
    
    // MARK: Database
    
    private func saveToCurrentUser(userSearchRequest request: UserSearchRequest) {
        userDataService.saveToCurrentUser(userSearchRequest: request) { (error) in
            if let error = error { print(error) }
        }
    }
    
    // MARK: Container View Controllers
    
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
            searchFlightsWithUserDefaults()
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
            searchFlightsWithUserDefaults()
        }
    }
    
    private func presentFlightDetails(forCellAt indexPath: IndexPath, completion: (() -> Void)? = nil) {
        let data = flights[indexPath.row]
        let flightDetailsVC = FlightDetailsVC()
        flightDetailsVC.flightData = data
        navigationController?.pushViewController(flightDetailsVC, animated: true)
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = FlightDataTableViewHeaderView()
        let attributes = [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)]
        let count = NSAttributedString(string: String(flights.count), attributes: attributes)
        let sortedBy = NSAttributedString(string: "Price", attributes: attributes)
        let title = NSMutableAttributedString(string: "Showing ")
        title.append(count)
        title.append(NSAttributedString(string: " results, sorted by "))
        title.append(sortedBy)
        
        header.attributedText = title
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presentFlightDetails(forCellAt: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
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
