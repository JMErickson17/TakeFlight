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
    @IBOutlet weak var refineButton: StatusButton!
    
    weak var searchDelegate: AirportPickerVCDelegate?
    
    private var sortOptions = SortOptions()
    private var filterOptions: FilterOptions? {
        didSet { configureRefineButtonForFilterState() }
    }
    
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
        return airportPickerVC == nil && datePickerVC == nil && self.view.window != nil
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
            DispatchQueue.global(qos: .userInitiated).async {
                self.processedFlights = self.sort(flightData: self.flights, by: self.sortOptions.selectedSortOption)
            }
        }
    }
    
    private var processedFlights = [FlightData]() {
        didSet {
            DispatchQueue.main.async {
                self.flightDataTableView.reloadData()
            }
        }
    }
    
    private var carriers: [String] {
        return flights.map({ $0.departingFlight.carrier })
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
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if flights.isEmpty {
            searchFlightsWithUserDefaults()
        }
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
            searchVC(self, dismissDatePicker: true)
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
    
    @IBAction func refineButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "toSortFilterVC", sender: nil)
    }
    
    
    @IBAction func roundTripButtonTapped(_ sender: UIButton) {
        selectedSearchType = .roundTrip
    }
    
    @IBAction func oneWayButtonTapped(_ sender: UIButton) {
        selectedSearchType = .oneWay
    }
    
    // MARK: Delegate Methods
    
    func searchVC(_ searchVC: SearchVC, clearLocations: Bool) {
        if clearLocations {
            origin = nil
            destination = nil
        }
    }
    
    func searchVC(_ searchVC: SearchVC, clearDates: Bool) {
        if clearDates {
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
    
    private func configureRefineButtonForFilterState() {
        if let filterOptions = filterOptions {
            refineButton.shouldShowstatusIndicator = filterOptions.hasActiveFilters
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
    
    // MARK: Sort and Filter
    
    private func sortProcessedFlights() {
        self.processedFlights = sort(flightData: processedFlights, by: sortOptions.selectedSortOption)
        self.flightDataTableView.reloadData()
    }
    
    private func filterProcessedFlights() {
        let filteredFlights = filter(flightData: flights, with: filterOptions)
        self.processedFlights = sort(flightData: filteredFlights, by: sortOptions.selectedSortOption)
        self.flightDataTableView.reloadData()
        // TODO: Fix TableView not scrolling
        if !self.processedFlights.isEmpty {
            self.flightDataTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        }
    }
    
    private func sort(flightData: [FlightData], by sortOption: SortOptions.Option) -> [FlightData] {
        guard !flightData.isEmpty else { return flightData }
        var flightData = flightData
        
        switch sortOption {
        case .price: flightData.sort { $0.saleTotal < $1.saleTotal}
        case .duration: flightData.sort { $0.departingFlight.duration < $1.departingFlight.duration }
        case .takeoffTime: flightData.sort { $0.departingFlight.departureTime < $1.departingFlight.departureTime }
        case .landingTime: flightData.sort { $0.departingFlight.arrivalTime < $1.departingFlight.arrivalTime }
        }
        return flightData
    }
    
    private func filter(flightData: [FlightData], with filterOptions: FilterOptions?) -> [FlightData] {
        if flightData.isEmpty || filterOptions == nil { return flightData }
        
        return flightData.filter { flight -> Bool in
            var isIncluded = true
            
            if let activeCarrierFilters = filterOptions?.activeCarrierFilters {
                let carriers = activeCarrierFilters.map({ $0.name })
                if carriers.contains(flight.departingFlight.carrier) {
                    isIncluded = false
                }
            }
            
            if let maxStops = filterOptions?.maxStops?.rawValue {
                if flight.departingFlight.stopCount > maxStops {
                    isIncluded = false
                }
            }
            
            if let maxDuration = filterOptions?.maxDuration {
                if flight.departingFlight.duration > maxDuration * 60 {
                    isIncluded = false
                }
            }
            return isIncluded
        }
    }
    
    // MARK: Database
    
    private func saveToCurrentUser(userSearchRequest request: UserSearchRequest) {
        userDataService.saveToCurrentUser(userSearchRequest: request) { (error) in
            if let error = error { print(error) }
        }
    }
    
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? SortFilterVC {
            destination.delegate = self
            destination.selectedSortOption = self.sortOptions.selectedSortOption
            if let filterOptions = filterOptions {
                destination.filterOptions = filterOptions
            } else {
                var filterOptions = FilterOptions()
                filterOptions.setupCarriers(with: carriers)
                destination.filterOptions = filterOptions
            }
        }
    }
    
    // MARK: Container View Controllers
    
    private func presentAirportPicker(withTag tag: Int, completion: (() -> Void)? = nil) {
        guard airportPickerVC == nil else { return }
        if datePickerVC != nil { searchVC(self, dismissDatePicker: true) }
        
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
    
    func searchVC(_ searchVC: SearchVC, dismissAirportPicker: Bool) {
        if dismissAirportPicker {
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
        if airportPickerVC != nil { searchVC(self, dismissAirportPicker: true) }
        originTextField.resignFirstResponder()
        destinationTextField.resignFirstResponder()
        
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
    
    func searchVC(_ searchVC: SearchVC, dismissDatePicker: Bool) {
        if dismissDatePicker {
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
        let data = processedFlights[indexPath.row]
        let flightDetailsVC = FlightDetailsVC()
        flightDetailsVC.flightData = data
        navigationController?.pushViewController(flightDetailsVC, animated: true)
    }
}

// MARK: - UITableView

extension SearchVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let flightData = processedFlights[indexPath.row]
        
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
        let count = NSAttributedString(string: String(processedFlights.count), attributes: attributes)
        let sortedByString = sortOptions.selectedSortOption.rawValue
        let sortedBy = NSAttributedString(string: sortedByString, attributes: attributes)
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
        return processedFlights.count
    }
}

// MARK: - UITextFieldDelegate

extension SearchVC: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        guard textField.tag == 3 || textField.tag == 4 else { return true }
        presentDatePicker()
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 1 || textField.tag == 2 {
            searchVC(self, dismissDatePicker: true)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text == "" {
            handleClearTextField(textField)
        }
        searchVC(self, dismissAirportPicker: true)
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
                searchVC(self, dismissAirportPicker: true)
            }
        } else {
            guard query.count >= 1 else { return }
            presentAirportPicker(withTag: textField.tag, completion: {
                self.searchDelegate?.airportPickerVC(self.searchDelegate as! AirportPickerVC, searchQueryDidChange: true, withQuery: query)
            })
        }
    }
}

// MARK: - SearchVC+SortFilterVCDelegate

extension SearchVC: SortFilterVCDelegate {
    
    func sortFilterVC(_ sortFilterVC: SortFilterVC, sortOptionDidChangeTo option: SortOptions.Option) {
        self.sortOptions.setSelectedSortOption(to: option)
        self.sortProcessedFlights()
    }
    
    func sortFilterVC(_ sortFilterVC: SortFilterVC, filterOptionsDidChangeTo options: FilterOptions?) {
        self.filterOptions = options
        self.filterProcessedFlights()
    }
}
