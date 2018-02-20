//
//  ExploreViewModel.swift
//  TakeFlight
//
//  Created by Justin Erickson on 1/30/18.
//  Copyright © 2018 Justin Erickson. All rights reserved.
//

import Foundation
import CoreLocation
import RxSwift
import RxCocoa

class ExploreViewModel {
    
    // MARK: ViewController Properties
    
    var tableData: BehaviorRelay = BehaviorRelay<[Section<Destination>]>(value: [])
    
    // MARK: Properties
    
    private let destinationService: DestinationService!
    
    private var _tableData: [Section<Destination>]! {
        didSet {
            self.tableData.accept(_tableData)
        }
    }
    
    private let topRatedCities = ["New York", "Philadelphia", "Honolulu", "San Fransico", "Washington DC", "Miami", "Los Angeles", "Seattle", "Denver", "Las Vegas", "Orlando"]
    
    // MARK: Lifecycle
    
    init(destinationService: DestinationService) {
        self.destinationService = destinationService
        setupTableData()
    }
    
    // MARK: Setup
    
    private func setupTableData() {
        print(destinationService.destinations.count)
        let popularDestinations = destinationService.destinations.filter { topRatedCities.contains($0.city) }
        let largeCities = destinationService.destinations.filter { $0.population > 800000 }
        
        self._tableData = [
            Section(title: "Popular Destinations", items: popularDestinations),
            Section(title: "Big Cities", items: largeCities)
        ]
        
        if let origin = UserDefaultsService.instance.origin {
            let nearby = destinationService.destinations.filter { $0.coordinates.clLocation.distance(from: origin.coordinates.clLocation) < 1000000 }
            if !nearby.isEmpty {
                _tableData.append(Section(title: "Nearby \(origin.city)", items: nearby))
            }
        }
    }
    
    // MARK: Convenience
    
    func destination(for indexPath: IndexPath) -> Destination {
        return tableData.value[indexPath.section].items[indexPath.row]
    }
    
    func title(for section: Int) -> String {
        return tableData.value[section].title
    }
    
    
    func items(for section: Int) -> [Destination] {
        return _tableData[section].items
    }
}
