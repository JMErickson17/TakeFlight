//
//  FlightDataManager.swift
//  TakeFlight
//
//  Created by Justin Erickson on 1/18/18.
//  Copyright © 2018 Justin Erickson. All rights reserved.
//

import Foundation
import RxSwift

class FlightDataManager {
    
    // MARK: Properties
    
    private(set) var processedFlightData: [FlightData]
    
    var flightData: [FlightData] {
        didSet {
            processedFlightData = processFlightsWithCurrentOptions()
        }
    }
    
    var sortOption: SortOption {
        didSet {
            processedFlightData = processFlightsWithCurrentOptions()
        }
    }
    
    var filterOptions: FlightFilterOptions {
        didSet {
            processedFlightData = processFlightsWithCurrentOptions()
            hasActiveFilters.value = filterOptions.hasActiveFilters
        }
    }
    
    var hasActiveFilters = Variable<Bool>(false)
    
    // MARK: Lifecycle
    
    init(flightData: [FlightData], sortOption: SortOption, filterOptions: FlightFilterOptions) {
        self.flightData = flightData
        self.processedFlightData = [FlightData]()
        self.sortOption = sortOption
        self.filterOptions = filterOptions
        defer {
            self.processedFlightData = processFlightsWithCurrentOptions()
        }
    }
    
    init() {
        self.flightData = [FlightData]()
        self.processedFlightData = [FlightData]()
        self.sortOption = .price
        self.filterOptions = FlightFilterOptions()
    }
    
    // MARK: Convenience
    
    private func processFlightsWithCurrentOptions() -> [FlightData] {
        let sortedFlights = sort(flights: flightData, by: sortOption)
        let filteredFlights = filter(flights: sortedFlights, by: filterOptions)
        return filteredFlights
    }
    
    private func sort(flights: [FlightData], by sortOption: SortOption) -> [FlightData] {
        if flights.isEmpty { return flights }
        
        switch sortOption {
        case .price: return flights.sorted { $0.saleTotal < $1.saleTotal}
        case .duration: return flights.sorted { $0.departingFlight.duration < $1.departingFlight.duration }
        case .takeoffTime: return flights.sorted { $0.departingFlight.departureTime < $1.departingFlight.departureTime }
        case .landingTime: return flights.sorted { $0.departingFlight.arrivalTime < $1.departingFlight.arrivalTime }
        }
    }
    
    private func filter(flights: [FlightData], by filterOptions: FlightFilterOptions) -> [FlightData] {
        if flights.isEmpty { return flights }
        
        return flights.filter({ flight -> Bool in
            var isIncluded = true
            
            let filteredCarriers = filterOptions.filteredCarriers
            if filteredCarriers.contains(flight.departingFlight.carrier) {
                isIncluded = false
            }
            
            
            let maxStops = filterOptions.maxStops
            if flight.departingFlight.stopCount > maxStops.rawValue {
                isIncluded = false
            }
            
            
            let maxDuration = filterOptions.maxDuration
            if flight.departingFlight.duration > maxDuration * 60 {
                isIncluded = false
            }
            
            
            return isIncluded
        })
        
    }
}
