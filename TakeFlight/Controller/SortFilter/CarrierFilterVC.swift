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
        
        var title: String {
            switch self {
            case .includedInCurrentResults:
                return "In Current Search"
            case .notIncludedInCurrentResults:
                return "All"
            }
        }
    }
    
    private struct Section {
        var type: SectionType
        var items: [CarrierData]
    }
    
    // MARK: Properties
    
    weak var delegate: CarrierFilterVCDelegate?
    var carrierData: [CarrierData]?
    
    private lazy var sections: [Section] = {
        let sections = [
            Section(type: .includedInCurrentResults, items: (carrierData?.filter { $0.isInCurrentSearch == true }) ?? [CarrierData]()),
            Section(type: .notIncludedInCurrentResults, items: (carrierData?.filter { $0.isInCurrentSearch == false }) ?? [CarrierData]())
        ]
        return sections
    }()
    
    private func setupTableData() {
        
    }

    // MARK: Table view data source
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Constants.carrierPickerCell, for: indexPath) as? CarrierPickerCell {
            switch indexPath.section {
            case 0:
                let carrier = sections[0].items[indexPath.row]
                cell.delegate = self
                cell.configureCell(withCarrierData: carrier)
                return cell
            case 1:
                let carrier = sections[1].items[indexPath.row]
                cell.delegate = self
                cell.configureCell(withCarrierData: carrier)
                return cell
            default: break
            }
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].items.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].type.title
    }
}

// MARK: - CarrierFilterVC+CarrierPickerCellDelegate

extension CarrierFilterVC: CarrierPickerCellDelegate {
    func carrierPickerCell(_ carrierPickerCell: CarrierPickerCell, didUpdateCarrierData carrierData: CarrierData) {
        if let index = self.carrierData?.index(where: { $0.carrier == carrierData.carrier}) {
            self.carrierData?[index] = carrierData
            delegate?.carrierFilterVC(self, didUpdateCarrierData: carrierData)
        }
    }
}
