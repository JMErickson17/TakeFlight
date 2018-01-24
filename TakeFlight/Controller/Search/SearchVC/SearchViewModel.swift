//
//  SearchViewModel.swift
//  TakeFlight
//
//  Created by Justin Erickson on 1/16/18.
//  Copyright © 2018 Justin Erickson. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct SearchViewModel {
    
    // MARK: View Controller Properties
    
    private(set) var originText = Variable<String>("")
    private(set) var destinationText = Variable<String>("")
    private(set) var departureDateText = Variable<String>("")
    private(set) var returnDateText = Variable<String>("")
    private(set) var selectedSearchType = Variable<SearchType>(.oneWay)
    private(set) var currentSearchState = Variable<SearchState?>(nil)
    private(set) var flights = Variable<[FlightData]>([])
    
    var origin: Airport? {
        didSet {
            userDefaults.origin = origin
            flightSearchRequest.origin = origin
            originText.value = origin?.searchRepresentation ?? ""
        }
    }
    
    var destination: Airport? {
        didSet {
            userDefaults.destination = destination
            flightSearchRequest.destination = destination
            destinationText.value = destination?.searchRepresentation ?? ""
        }
    }
    
    var departureDate: Date? {
        didSet {
            userDefaults.departureDate = departureDate
            flightSearchRequest.departureDate = departureDate
            departureDateText.value = formatted(date: departureDate)
        }
    }
    
    var returnDate: Date? {
        didSet {
            userDefaults.returnDate = returnDate
            flightSearchRequest.returnDate = returnDate
            returnDateText.value = formatted(date: returnDate)
        }
    }
    
    var searchType: SearchType {
        didSet {
            configureViewModel(for: searchType)
        }
    }
    
    var sortOption: SortOption {
        didSet {
            flightDataManager.sortOption = sortOption
            updateFlights()
        }
    }
    
    var carrierData: [CarrierData] {
        get {
            let currentSearchCarriers = flightDataManager.flightData.map { $0.departingFlight.carrier }
            let filteredCarriers = flightDataManager.filterOptions.filteredCarriers
            return carrierService.carriers.map { carrier in
                return CarrierData(carrier: carrier, isInCurrentSearch: currentSearchCarriers.contains(carrier), isFiltered: filteredCarriers.contains(carrier))
            }
        }
        set {
            self.flightDataManager.filterOptions.filteredCarriers = newValue.filter { $0.isFiltered == true }.map { $0.carrier }
            updateFlights()
        }
    }
    
    var flightDataHeaderString: NSAttributedString {
        let attributes = [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)]
        let count = NSAttributedString(string: String(flights.value.count), attributes: attributes)
        let sortedBy = NSAttributedString(string: sortOption.description, attributes: attributes)
        let headerString = NSMutableAttributedString(string: "Showing ")
        headerString.append(count)
        headerString.append(NSAttributedString(string: " results, sorted by "))
        headerString.append(sortedBy)
        return headerString
    }
    
    var flightDataManager = FlightDataManager()
    
    // MARK: Private Properties
    
    private var flightSearchRequest = FlightSearchRequest()
    private let requestManager: QPXExpress
    private let userService: UserService
    private let carrierService: CarrierService
    private let userDefaults = UserDefaultsService.instance
    
    private let formatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = Calendar.current.timeZone
        dateFormatter.locale = Calendar.current.locale
        dateFormatter.dateFormat = "MMMM dd"
        return dateFormatter
    }()
    
    
    // MARK: Lifecycle
    
    init(requestManager: QPXExpress, userService: UserService, carrierService: CarrierService) {
        self.requestManager = requestManager
        self.userService = userService
        self.carrierService = carrierService
        self.sortOption = .price
        self.searchType = userDefaults.searchType
        
        defer {
            self.origin = userDefaults.origin
            self.destination = userDefaults.destination
            self.departureDate = userDefaults.departureDate
            self.returnDate = userDefaults.returnDate
            self.selectedSearchType.value = searchType
        }
    }
    
    // MARK: Convenience
    
    mutating func resetSortAndFilters() {
        sortOption = .price
        flightDataManager.filterOptions.resetFilters()
        carrierData = carrierService.carriers.map { carrier in
            CarrierData(carrier: carrier,
                        isInCurrentSearch: flightDataManager.flightData.map { $0.departingFlight.carrier }.contains(carrier),
                        isFiltered: false)
        }
    }
    
    private func formatted(date: Date?) -> String {
        guard let date = date else { return "" }
        return formatter.string(from: date)
    }
    
    // MARK: Configuration
    
    private mutating func configureViewModel(for searchType: SearchType) {
        if searchType == .oneWay {
            self.returnDate = nil
        }
        userDefaults.searchType = searchType
        selectedSearchType.value = searchType
        
        if currentSearchState.value == .searching {
            currentSearchState.value = .cancelled
        } else {
            removeAllFlights()
            currentSearchState.value = .noResults
        }
        searchFlights()
    }
    
    // MARK: Search Methods
    
    func searchFlights() {
        guard flightSearchRequest.isValid(for: searchType) else { return }
        guard let qpxRequest = requestManager.makeQPXRequest(withUserRequest: flightSearchRequest) else { return }
        saveToCurrentUser(request: flightSearchRequest)
        self.fetchFlightData(with: qpxRequest)
    }
    
    private func fetchFlightData(with request: QPXExpress.Request) {
        currentSearchState.value = .searching
        requestManager.fetch(qpxRequest: request) { (flightData, error) in
            guard self.currentSearchState.value != .cancelled else { return self.handleSearchError(FlightSearchError.searchCancelled) }
            if let error = error { return self.handleSearchError(error) }
            guard let flightData = flightData else { return self.handleSearchError(FlightSearchError.invalidReponse) }
            
            self.handleNewFlightData(flightData)
        }
    }
    
    private func handleNewFlightData(_ flightData: [FlightData]) {
        guard !flightData.isEmpty else {
            removeAllFlights()
            currentSearchState.value = .noResults
            return
        }
        
        self.flightDataManager.flightData = flightData
        self.currentSearchState.value = .someResults
        updateFlights()
    }
    
    private func handleSearchError(_ error: Error) {
        guard let flightSearchError = error as? FlightSearchError else {
            removeAllFlights()
            currentSearchState.value = .noResults
            print(error)
            return
        }
        
        switch flightSearchError {
        case .searchCancelled:
            removeAllFlights()
            currentSearchState.value = .noResults
        case .invalidReponse:
            removeAllFlights()
            currentSearchState.value = .noResults
        default: break
        }
    }
    
    func updateFlights() {
        self.flights.value = flightDataManager.processedFlightData
    }
    
    private func removeAllFlights() {
        self.flightDataManager.flightData.removeAll()
        self.flights.value.removeAll()
    }
    
    // MARK: Database
    
    private func saveToCurrentUser(request: FlightSearchRequest) {
        userService.saveToCurrentUser(userSearchRequest: request) { error in
            if let error = error { print(error) }
        }
    }
}
