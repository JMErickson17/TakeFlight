//
//  ExploreViewModel.swift
//  TakeFlight
//
//  Created by Justin Erickson on 1/30/18.
//  Copyright © 2018 Justin Erickson. All rights reserved.
//

import Foundation
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
    
    private var popularDestinations: [Destination] {
        return destinationService.destinations
    }
    
    // MARK: Lifecycle
    
    init(destinationService: DestinationService) {
        self.destinationService = destinationService
        setupTableData()
    }
    
    // MARK: Setup
    
    private func setupTableData() {
        self._tableData = [
            Section(title: "Popular Destinations", items: popularDestinations),
            Section(title: "Quick Get Aways", items: popularDestinations),
            Section(title: "Close to Home", items: popularDestinations)
        ]
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
