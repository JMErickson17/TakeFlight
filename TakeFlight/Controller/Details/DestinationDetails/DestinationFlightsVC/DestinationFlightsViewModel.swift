//
//  DestinationFlightsViewModel.swift
//  TakeFlight
//
//  Created by Justin Erickson on 2/21/18.
//  Copyright © 2018 Justin Erickson. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct DestinationFlightsViewModel {
    
    // MARK: View Controller Properties
    
    var originTextFieldText: BehaviorRelay<String> = BehaviorRelay(value: "")
    var cheapestFlights: BehaviorRelay<[FlightData]> = BehaviorRelay(value: [])
    
    // MARK: Properties
    
    private let destination: Destination
    private let flightDataService: QPXExpress
    private let airportService: AirportService
    private let userDefaults: UserDefaultsService = UserDefaultsService.instance
    
    // MARK: Initialization
    
    init(flightDataService: QPXExpress, airportService: AirportService, destination: Destination) {
        self.flightDataService = flightDataService
        self.airportService = airportService
        self.destination = destination
        setupViewModel()
    }
    
    // MARK: Setup
    
    private func setupViewModel() {
        configureViewModel(for: destination)
        
        if let origin = userDefaults.origin {
            originTextFieldText.accept("From \(origin.name)")
        } else {
            originTextFieldText.accept("Select an origin.")
        }
    }
    
    private func configureViewModel(for destination: Destination) {
        searchFlights(for: destination)
    }
    
    // MARK: Flights Search
    
    private func searchFlights(for destination: Destination) {
        guard let originAirport = userDefaults.origin else { return }
        guard let destinationAirportCode = destination.airports.first else { return }
        guard let destinationAirport = airportService.airport(withIdentifier: destinationAirportCode) else { return }
        let departureDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        
        let request = flightDataService.makeQPXRequest(adultCount: 1,
                                                       childCount: 0,
                                                       infantCount: 0,
                                                       from: originAirport,
                                                       to: destinationAirport,
                                                       departing: departureDate,
                                                       returning: nil)
        
        flightDataService.fetch(qpxRequest: request) { flightData, error in
            if let error = error { return self.handleFlightDataError(error) }
            if let flightData = flightData { return self.handleNewFlightData(flightData) }
        }
    }
    
    private func handleFlightDataError(_ error: Error) {
        print(error)
    }
    
    
    private func handleNewFlightData(_ flightData: [FlightData]) {
        var cheapestFlights = [Carrier: FlightData]()
        let carriers = flightData.map { $0.departingFlight.carrier }

        for carrier in carriers {
            let flightsByCarrier = flightData.filter { $0.departingFlight.carrier == carrier }
            if let cheapestFlight = flightsByCarrier.sorted(by: { $0.saleTotal < $1.saleTotal }).first {
                cheapestFlights[carrier] = cheapestFlight
            }
        }
        
        self.cheapestFlights.accept(cheapestFlights.map { $0.value }.sorted(by: { $0.saleTotal < $1.saleTotal }))
    }
    
    // MARK: Public API
    
    func flight(for indexPath: IndexPath) -> FlightData {
        return cheapestFlights.value[indexPath.row]
    }
}
