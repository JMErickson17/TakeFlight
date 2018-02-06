//
//  SearchViewModelTests.swift
//  TakeFlightTests
//
//  Created by Justin Erickson on 2/6/18.
//  Copyright © 2018 Justin Erickson. All rights reserved.
//

import UIKit
import RxSwift
import XCTest
import Quick
import Nimble
@testable import TakeFlight

class SearchViewModelTests: XCTestCase {
    
    var searchViewModel: SearchViewModel!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func setUp() {
        super.setUp()
        
        let requestManager = QPXExpress()
        searchViewModel = SearchViewModel(requestManager: requestManager,
                                          userService: appDelegate.firebaseUserService!,
                                          carrierService: appDelegate.firebaseCarrierService!)
    }
    
    func testResetSortAndFilters_resetsSortAndFilters() {
        searchViewModel.resetSortAndFilters()
        
        // Test SortOption
        let sortOption = searchViewModel.sortOption
        expect(sortOption).to(equal(SortOption.price))
        
        // Test activeFiltersVariable
        let activeFilters = searchViewModel.hasActiveFilters.value
        expect(activeFilters).to(equal(false))
        
        // Test all carriers.isFiltered are false
        let carriers = searchViewModel.carrierData
        for carrier in carriers {
            expect(carrier.isFiltered).to(equal(false))
        }
    }
    
    func testSearchFlights_returnsFromInvalidRequest() {
        // Clear user dafaults
        searchViewModel.origin = nil
        searchViewModel.destination = nil
        searchViewModel.departureDate = nil
        searchViewModel.returnDate = nil
        searchViewModel.currentSearchState.value = .noResults
        
        // Search Flights
        searchViewModel.searchFlights()
        
        // Verify current search state did not change to .searching
        let searchStateAfterTest = searchViewModel.currentSearchState.value
        expect(searchStateAfterTest).toNot(equal(SearchState.searching))
    }
    
    func testSearchFlights_searchesOneWayFlights() {
        let mockOrlandoAirport = Airport(name: "", city: "", state: "", stateAbbreviation: "", country: "", municipality: "", iata: "MCO", lat: 0, lon: 0)
        let mockLosAngelesAirport = Airport(name: "", city: "", state: "", stateAbbreviation: "", country: "", municipality: "", iata: "LAX", lat: 0, lon: 0)
        
        // Set search params
        searchViewModel.origin = mockOrlandoAirport
        searchViewModel.destination = mockLosAngelesAirport
        searchViewModel.departureDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())
        searchViewModel.currentSearchState.value = .noResults
        searchViewModel.searchType = .oneWay
        
        searchViewModel.searchFlights()
        
        // Verify current search state did change to .searching
        let searchStateAfterTest = searchViewModel.currentSearchState.value
        expect(searchStateAfterTest).to(equal(SearchState.searching))
        
        
        // Verify flights is empty
        let flightsCount = searchViewModel.flights.value.count
        expect(flightsCount).to(equal(0))
        
        // Verify empty flights label was updated
        let emptyFlightLabelText = searchViewModel.emptyFlightDataLabelText.value
        expect(emptyFlightLabelText).to(equal("Looks like were missing some information needed for this search."))
    }
}
