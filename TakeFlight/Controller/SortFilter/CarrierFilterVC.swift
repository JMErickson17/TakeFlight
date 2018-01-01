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
    
    weak var delegate: CarrierFilterVCDelegate?
    
    var filterableCarriers: [FilterableCarrier]?

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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterableCarriers?.count ?? 0
    }
}

// MARK: - CarrierFilterVC+CarrierPickerCellDelegate

extension CarrierFilterVC: CarrierPickerCellDelegate {
    func carrierPickerCell(_ carrierPickerCell: CarrierPickerCell, didUpdateCarrier carrier: FilterableCarrier) {
        if let index = filterableCarriers?.index(where: { $0.name == carrier.name }) {
            filterableCarriers?[index] = carrier
            delegate?.carrierFilterVC(self, didUpdateCarrier: carrier)
        }
    }
}
