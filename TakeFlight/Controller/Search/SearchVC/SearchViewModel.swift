//
//  SearchViewModel.swift
//  TakeFlight
//
//  Created by Justin Erickson on 1/16/18.
//  Copyright © 2018 Justin Erickson. All rights reserved.
//

import Foundation
import RxSwift

struct SearchViewModel {
    
    // MARK: View Controller Properties
    
    var originText = Variable<String>("")
    var destinationText = Variable<String>("")
    var departureDateText = Variable<String>("")
    var returnDateText = Variable<String>("")
    var selectedSearchType = Variable<SearchType>(.oneWay)
    var currentSearchState = Variable<SearchState?>(nil)
    var flights = Variable<[FlightData]>([])
    
    var flightSearchRequest = FlightSearchRequest()
    var flightDataManager = FlightDataManager()
    
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
                return (carrier: carrier, isInCurrentSearch: currentSearchCarriers.contains(carrier),
                        isFiltered: filteredCarriers.contains(carrier))
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
    
    // MARK: Private Properties
    
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
    
    private func formatted(date: Date?) -> String {
        guard let date = date else { return "" }
        return formatter.string(from: date)
    }
    
    private mutating func configureViewModel(for searchType: SearchType) {
        switch searchType {
        case .oneWay:
            returnDate = nil
            
        case .roundTrip: break
        }
        userDefaults.searchType = searchType
        selectedSearchType.value = searchType
        removeAllFlights()
        currentSearchState.value = .noResults
        searchFlights()
    }
    
    // MARK: Search Methods
    
    func searchFlights() {
        if flightSearchRequest.isValid(for: searchType), let qpxRequest = requestManager.makeQPXRequest(withUserRequest: flightSearchRequest) {
            currentSearchState.value = .searching
            saveToCurrentUser(request: flightSearchRequest)
            
            requestManager.fetch(qpxRequest: qpxRequest, completion: { (flightData, error) in
                if let error = error { return self.handleSearchError(error) }
                if let flightData = flightData {
                    self.handleNewFlightData(flightData)
                } else {
                    self.handleSearchError(FlightSearchError.invalidReponse)
                }
            })
        }
    }
    
    private func handleNewFlightData(_ flightData: [FlightData]) {
        guard currentSearchState.value != .cancelled else { handleSearchError(FlightSearchError.searchCancelled); return }
        
        self.flightDataManager.flightData = flightData
        self.flights.value = flightDataManager.processedFlightData
        if flights.value.count == 0 {
            currentSearchState.value = .noResults
        } else {
            currentSearchState.value = .someResults
        }
    }
    
    private func handleSearchError(_ error: Error) {
        self.flights.value.removeAll()
        
        if let flightSearchError = error as? FlightSearchError {
            if flightSearchError == .searchCancelled {
                currentSearchState.value = .noResults
                searchFlights()
                return
            }
        }
        currentSearchState.value = .noResults
        print(error)
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
