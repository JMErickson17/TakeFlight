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
    
    // MARK: Lifecycle
    
    init(destinationService: DestinationService) {
        self.destinationService = destinationService
        setupTableData()
    }
    
    // MARK: Setup
    
    private func setupTableData() {
        let popularDestinations = destinationService.destinations
        
        self._tableData = [
            Section(title: "Popular Destinations", items: popularDestinations),
            Section(title: "Quick Get Aways", items: popularDestinations)
        ]
    }
    
    // MARK: Convenience
    
    func image(for destination: Destination, completion: @escaping (UIImage?) -> Void) {
        destinationService.image(for: destination) { image, error in
            if let error = error { print(error); return completion(nil) }
            guard let image = image else { return completion(nil) }
            DispatchQueue.main.async {
                completion(image)
            }
        }
    }
    
    func destination(for indexPath: IndexPath) -> Destination {
        return _tableData[indexPath.section].items[indexPath.row]
    }
    
    func title(for section: Int) -> String {
        return _tableData[section].title
    }
}
