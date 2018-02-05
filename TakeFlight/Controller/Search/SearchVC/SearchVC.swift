//
//  ViewController.swift
//  TakeFlight
//
//  Created by Justin Erickson on 10/1/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Firebase

class SearchVC: UIViewController {
    
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
    
    lazy var userService: UserService = appDelegate.firebaseUserService!
    
    private lazy var carrierService: CarrierService = FirebaseCarrierService(database: Firestore.firestore())
    private lazy var viewModel = SearchViewModel(requestManager: QPXExpress(),
                                                 userService: userService,
                                                 carrierService: carrierService)
    private var disposeBag = DisposeBag()
    private var airportPickerVC: AirportPickerVC?
    private var datePickerVC: DatePickerVC?
    private let refreshControl = UIRefreshControl()
    private var passengerOptionsDidChange = false
    
    private var shouldSearch: Bool {
        return airportPickerVC == nil && datePickerVC == nil && self.view.window != nil
    }

    private lazy var emptyFlightsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 0
        label.isHidden = true
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
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let backButton = UIBarButtonItem()
        backButton.title = "Back"
        navigationItem.backBarButtonItem = backButton
        self.tabBarController?.tabBar.isHidden = false
        
        viewModel.synchronizeUserDefaults()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if viewModel.flightDataManager.flightData.isEmpty && shouldSearch || passengerOptionsDidChange {
            viewModel.searchFlights()
            passengerOptionsDidChange = false
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
        
        if let userDepartureDate = viewModel.departureDate {
            if userDepartureDate < Date() {
                clearDates()
            }
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
        
        flightDataTableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(tableViewShouldRefresh), for: .valueChanged)
        refreshControl.tintColor = .primaryBlue
        
        let oneWayCell = UINib(nibName: Constants.ONE_WAY_FLIGHT_DATA_CELL, bundle: nil)
        flightDataTableView.register(oneWayCell, forCellReuseIdentifier: Constants.ONE_WAY_FLIGHT_DATA_CELL)
        
        let roundTripCell = UINib(nibName: Constants.ROUND_TRIP_FLIGHT_DATA_CELL, bundle: nil)
        flightDataTableView.register(roundTripCell, forCellReuseIdentifier: Constants.ROUND_TRIP_FLIGHT_DATA_CELL)
    }
    
    private func bindViewModel() {
        viewModel.flights.asObservable().subscribe(onNext: { flightData in
            self.flightDataTableView.reloadData()
        }).disposed(by: disposeBag)
        
        viewModel.selectedSearchType.asObservable().subscribe(onNext: { searchType in
            self.configureViewForSearchType(searchType)
        }).disposed(by: disposeBag)
        
        viewModel.currentSearchState.asObservable().subscribe(onNext: { searchState in
            self.configureViewForSearchState(searchState)
        }).disposed(by: disposeBag)
        
        viewModel.hasActiveFilters.asObservable().subscribe(onNext: { hasActiveFilters in
            self.configureRefineButton(hasActiveFilters: hasActiveFilters)
        }).disposed(by: disposeBag)
        
        viewModel.originText.asObservable().bind(to: originTextField.rx.text).disposed(by: disposeBag)
        viewModel.destinationText.asObservable().bind(to: destinationTextField.rx.text).disposed(by: disposeBag)
        viewModel.departureDateText.asObservable().bind(to: departureDateTextField.rx.text).disposed(by: disposeBag)
        viewModel.returnDateText.asObservable().bind(to: returnDateTextField.rx.text).disposed(by: disposeBag)
        viewModel.emptyFlightDataLabelText.asObservable().bind(to: emptyFlightsLabel.rx.text).disposed(by: disposeBag)
    }
    
    func updateUserDefaultsAndSearch() {
        viewModel.synchronizeUserDefaults()
        switch viewModel.selectedSearchType.value {
        case .oneWay:
            if let _ = viewModel.departureDate {
                viewModel.searchFlights()
            } else {
                presentDatePicker()
            }
        case .roundTrip:
            if let _ = viewModel.departureDate, let _ = viewModel.returnDate {
                viewModel.searchFlights()
            } else {
                presentDatePicker()
            }
        }
    }
    
    // MARK: Actions
    
    @IBAction func refineButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "toSortFilterVC", sender: nil)
    }
    
    @IBAction func roundTripButtonTapped(_ sender: UIButton) {
        viewModel.searchType = .roundTrip
    }
    
    @IBAction func oneWayButtonTapped(_ sender: UIButton) {
        viewModel.searchType = .oneWay
    }
    
    
    func clearLocations() {
        viewModel.origin = nil
        viewModel.destination = nil
    }
    
    func clearDates() {
        viewModel.departureDate = nil
        viewModel.returnDate = nil
    }
    
    @objc func tableViewShouldRefresh() {
        if shouldSearch {
            viewModel.searchFlights()
            refreshControl.endRefreshing()
        }
    }
    
    // MARK: View Configuration
    
    private func configureViewForSearchType(_ searchType: SearchType) {
        switch searchType {
        case .oneWay:
            oneWayButton.layer.opacity = 1
            roundTripButton.layer.opacity = 0.5
            returnDateTextField.placeholder = "One Way"
            oneWayButton.isEnabled = false
            roundTripButton.isEnabled = true
        case.roundTrip:
            oneWayButton.layer.opacity = 0.5
            roundTripButton.layer.opacity = 1
            returnDateTextField.placeholder = "Return Date"
            oneWayButton.isEnabled = true
            roundTripButton.isEnabled = false
        }
    }
    
    private func configureViewForSearchState(_ searchState: SearchState?) {
        guard let searchState = searchState else { return }
        
        switch searchState {
        case .noResults:
            showEmptyFlightsLabel()
            activitySpinner.stopAnimating()
        case .searching:
            hideEmptyFlightsLabel()
            activitySpinner.startAnimating()
        case .cancelled:
            showEmptyFlightsLabel()
            activitySpinner.stopAnimating()
        case .someResults:
            hideEmptyFlightsLabel()
            activitySpinner.stopAnimating()
        }
    }
    
    private func configureRefineButton(hasActiveFilters: Bool) {
        refineButton.shouldShowstatusIndicator = hasActiveFilters
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
    
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? SortFilterVC {
            destination.delegate = self
            destination.selectedSortOption = viewModel.sortOption
            destination.filterOptions = viewModel.flightDataManager.filterOptions
            destination.carrierData = viewModel.carrierData
            destination.passengerOptions = viewModel.passengerOptions
        }
    }
    
    // MARK: Container View Controllers
    
    private func presentAirportPicker(withTag tag: Int, completion: (() -> Void)?) {
        guard airportPickerVC == nil else { return }
        dismissDatePicker()
        
        airportPickerVC = AirportPickerVC()
        airportPickerVC?.delegate = self
        airportPickerVC!.currentTextFieldTag = tag
        
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
    
    func dismissAirportPicker() {
        guard airportPickerVC != nil else { return }
        guard childViewControllers.contains(airportPickerVC!) else { return }
        airportPickerVC!.willMove(toParentViewController: nil)
        airportPickerVC!.view.removeFromSuperview()
        airportPickerVC!.removeFromParentViewController()
        airportPickerVC = nil
        if shouldSearch {
            viewModel.searchFlights()
        }
    }
    
    private func presentDatePicker(completion: (() -> Void)? = nil) {
        guard datePickerVC == nil else { return }
        if airportPickerVC != nil { dismissAirportPicker() }
        originTextField.resignFirstResponder()
        destinationTextField.resignFirstResponder()
        
        datePickerVC = DatePickerVC()
        datePickerVC?.delegate = self
        datePickerVC?.departureDate = viewModel.departureDate
        datePickerVC?.returnDate = viewModel.returnDate
        
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
    
    func dismissDatePicker() {
        guard datePickerVC != nil else { return }
        guard childViewControllers.contains(datePickerVC!) else { return }
        datePickerVC!.willMove(toParentViewController: nil)
        datePickerVC!.view.removeFromSuperview()
        datePickerVC!.removeFromParentViewController()
        datePickerVC = nil
        
        if shouldSearch {
            viewModel.searchFlights()
        }
    }
    
    private func presentFlightDetails(forCellAt indexPath: IndexPath, completion: (() -> Void)? = nil) {
        let data = viewModel.flights.value[indexPath.row]
        let flightDetailsVC = FlightDetailsVCFactory.makeFlightDetailsVC(with: data)
        navigationController?.pushViewController(flightDetailsVC, animated: true)
    }
}

// MARK: - UITableView

extension SearchVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let flightData = viewModel.flights.value[indexPath.row]
        
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
        header.attributedText = viewModel.flightDataHeaderString
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
        return viewModel.flights.value.count
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
            dismissDatePicker()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text == "" {
            handleClearTextField(textField)
        } else {
            handleRestoreTextField(textField)
        }
        textField.resignFirstResponder()
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        handleClearTextField(textField)
        return true
    }
    
    func handleClearTextField(_ textField: UITextField) {
        switch textField.tag {
        case 1: viewModel.origin = nil
        case 2: viewModel.destination = nil
        default: break
        }
    }
    
    func handleRestoreTextField(_ textField: UITextField) {
        switch textField.tag {
        case 1 where textField.text != viewModel.originText.value:
            textField.text = viewModel.originText.value
        case 2 where textField.text != viewModel.destinationText.value:
            textField.text = viewModel.destinationText.value
        default: break
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let query = textField.text else { return }
        
        if airportPickerVC != nil && childViewControllers.contains(airportPickerVC!) {
            airportPickerVC?.searchQuery(didChangeTo: query)
        } else {
            guard query.count > 0 else { return }
            presentAirportPicker(withTag: textField.tag, completion: {
                self.airportPickerVC?.searchQuery(didChangeTo: query)
            })
        }
    }
}

// MARK:- DatePickerVCDelegate

extension SearchVC: DatePickerVCDelegate {
    func datePickerVC(_ datePickerVC: DatePickerVC, didUpdateDepartureDate date: Date) {
        viewModel.departureDate = date
    }
    
    func datePickerVC(_ datePickerVC: DatePickerVC, didUpdateReturnDate date: Date) {
        viewModel.returnDate = date
    }
    
    func datePickerVCClearDates(_ datePickerVC: DatePickerVC) {
        clearDates()
    }
    
    func datePickerVCDismiss(_ datePickerVC: DatePickerVC) {
        dismissDatePicker()
    }
}

// MARK:- AirportPickerVCDelegate

extension SearchVC: AirportPickerVCDelegate {
    func airportPickerVCDismiss(_ airportPickerVC: AirportPickerVC) {
        dismissAirportPicker()
    }
    
    
    func airportPickerVC(_ airportPickerVC: AirportPickerVC, didPickOriginAirport airport: Airport) {
        viewModel.origin = airport
        originTextField.resignFirstResponder()
    }
    
    func airportPickerVC(_ airportPickerVC: AirportPickerVC, didPickDestinationAirport airport: Airport) {
        viewModel.destination = airport
        destinationTextField.resignFirstResponder()
    }
}

// MARK:- SearchVC+SortFilterVCDelegate

extension SearchVC: SortFilterVCDelegate {
    func sortFilterVCDidResetSortAndFilter(_ sortFilterVC: SortFilterVC) {
        self.viewModel.resetSortAndFilters()
        self.viewModel.updateFlights()
    }
    
    func sortFilterVC(_ sortFilterVC: SortFilterVC, carrierDataDidChangeTo carrierData: [CarrierData]) {
        self.viewModel.carrierData = carrierData
    }
    
    func sortFilterVC(_ sortFilterVC: SortFilterVC, sortOptionDidChangeTo option: SortOption) {
        self.viewModel.sortOption = option
        self.viewModel.updateFlights()
    }
    
    func sortFilterVC(_ sortFilterVC: SortFilterVC, maxStopsDidChangeTo stops: MaxStops) {
        self.viewModel.flightDataManager.filterOptions.maxStops = stops
        self.viewModel.updateFlights()
    }
    
    func sortFilterVC(_ sortFilterVC: SortFilterVC, maxDurationDidChangeTo duration: Hour) {
        self.viewModel.flightDataManager.filterOptions.maxDuration = duration
        self.viewModel.updateFlights()
    }
    
    func sortFilterVC(_ sortFilterVC: SortFilterVC, didUpdate option: PassengerOption) {
        self.passengerOptionsDidChange = true
        self.viewModel.update(option)
    }
}
