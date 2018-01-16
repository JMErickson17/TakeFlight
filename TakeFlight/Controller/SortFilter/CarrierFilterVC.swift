//
//  AirlineFilterVC.swift
//  TakeFlight
//
//  Created by Justin Erickson on 12/27/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import UIKit

class CarrierFilterVC: UITableViewController {
    
    // MARK: Types
    
    private struct Constants {
        static let carrierPickerCell = "CarrierPickerCell"
    }
    
    private enum SectionType {
        case includedInCurrentResults
        case notIncludedInCurrentResults
    }
    
    private struct Section {
        var type: SectionType
        var items: [FilterableCarrier]
    }
    
    // MARK: Properties
    
    weak var delegate: CarrierFilterVCDelegate?
    
    var filteredCarriers: [FilterableCarrier]?
    var carriersInCurrentSearch: [FilterableCarrier]?
    
    private lazy var sections: [Section] = {
        let sections = [
            Section(type: .includedInCurrentResults, items: filteredCarriers ?? [FilterableCarrier]()),
            Section(type: .notIncludedInCurrentResults, items: filteredCarriers  ?? [FilterableCarrier]())
        ]
        return sections
    }()
    
    private func setupTableData() {
        
    }

    // MARK: Table view data source
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Constants.carrierPickerCell, for: indexPath) as? CarrierPickerCell {
            guard let filteredCarriers = filteredCarriers else { return UITableViewCell() }
            let carrier = filteredCarriers[indexPath.row]
            cell.delegate = self
            cell.configureCell(withFilterableCarrier: carrier)
            return cell
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCarriers?.count ?? 0
    }
}

// MARK: - CarrierFilterVC+CarrierPickerCellDelegate

extension CarrierFilterVC: CarrierPickerCellDelegate {
    func carrierPickerCell(_ carrierPickerCell: CarrierPickerCell, didUpdateCarrier carrier: FilterableCarrier) {
        if let index = filteredCarriers?.index(where: { $0.carrier == carrier.carrier }) {
            filteredCarriers?[index] = carrier
            delegate?.carrierFilterVC(self, didUpdateCarrier: carrier)
        }
    }
}
