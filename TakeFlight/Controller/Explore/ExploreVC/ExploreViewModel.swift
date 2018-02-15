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
            self.tableData.accept(trimmed(_tableData))
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
    
    private func trimmed(_ tableData: [Section<Destination>]) -> [Section<Destination>] {
        return tableData.map { Section(title: $0.title, items: $0.items.first(5)) }
    }
    
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
        return tableData.value[indexPath.section].items[indexPath.row]
    }
    
    func title(for section: Int) -> String {
        return tableData.value[section].title
    }
    
    func trimmedItems(for section: Int) -> [Destination] {
        return tableData.value[section].items
    }
    
    func allItems(for section: Int) -> [Destination] {
        return _tableData[section].items
    }
}
