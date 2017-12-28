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
    
    // MARK: Properties
    
    var filterableCarriers: [FilterableCarrier]?
    weak var delegate: CarrierFilterVCDelegate?
    
    private var containsFilteredCarriers: Bool {
        var containsFilters = false
        filterableCarriers?.forEach { carrier in
            if carrier.isFiltered {
                containsFilters = true
            }
        }
        return containsFilters
    }

    // MARK: Lifecycle
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if let filterableCarriers = filterableCarriers {
            delegate?.carrierFilterVC(self, setFilteredCarriersTo: filterableCarriers)
        }
    }

    // MARK: Table view data source
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Constants.carrierPickerCell, for: indexPath) as? CarrierPickerCell {
            guard let filterableCarriers = filterableCarriers else { return UITableViewCell() }
            let carrier = filterableCarriers[indexPath.row]
            cell.delegate = self
            cell.configureCell(withFilterableCarrier: carrier)
            return cell
        }
        return UITableViewCell()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterableCarriers?.count ?? 0
    }
}

// MARK: - CarrierFilterVC+CarrierPickerCellDelegate

extension CarrierFilterVC: CarrierPickerCellDelegate {
    func carrierPickerCell(_ carrierPickerCell: CarrierPickerCell, didUpdateFilterValueTo isSelected: Bool, for carrier: FilterableCarrier) {
        guard let filterableCarriers = filterableCarriers else { return }
        if let carrierIndex = filterableCarriers.index(where: { $0.name == carrier.name }) {
            self.filterableCarriers?[carrierIndex].isFiltered = !isSelected
        }
    }
}
