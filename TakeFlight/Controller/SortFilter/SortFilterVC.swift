//
//  SortFilterVC.swift
//  TakeFlight
//
//  Created by Justin Erickson on 12/26/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import UIKit

class SortFilterVC: UIViewController {
    
    // MARK: Types
    
    private struct Constants {
        static let toCarrierFilterVC = "toCarrierFilterVC"
        static let toStopFilterVC = "toStopFilterVC"
        static let toDurationFilterVC = "toDurationFilterVC"
        static let sortOptionCell = "SortOptionCell"
        static let filterOptionCell = "FilterOptionCell"
    }
    
    private struct Section {
        let title: String
        let items: [SortFilterOption]
    }
    
    // MARK: Properties
    
    @IBOutlet weak var tableView: UITableView!
    
    weak var delegate: SortFilterVCDelegate?
    private var tableData: [Section]?
    
    private let filterSegues = [Constants.toCarrierFilterVC, Constants.toStopFilterVC, Constants.toDurationFilterVC]
    
    var sortFilterOptions: SortFilterOptions? {
        didSet {
            if let sortFilterOptions = sortFilterOptions {
                tableData = [
                    Section(title: "Sort", items: sortFilterOptions.sortOptions),
                    Section(title: "Filter", items: sortFilterOptions.filterOptions)
                ]
            }
        }
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        delegate?.sortFilterOptions = sortFilterOptions
    }
    
    // MARK: Setup

    private func setupView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SortOptionCell.self, forCellReuseIdentifier: Constants.sortOptionCell)
        tableView.register(FilterOptionCell.self, forCellReuseIdentifier: Constants.filterOptionCell)
    }
    
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
        case Constants.toCarrierFilterVC:
            if let destination = segue.destination as? CarrierFilterVC {
                destination.filterableCarriers = sortFilterOptions?.filterableCarriers
                destination.delegate = self
            }
        case Constants.toStopFilterVC: break
        case Constants.toDurationFilterVC: break
        default: break
            
        }
    }
}

// MARK: - SortFilterVC+UITableViewDelegate & UITableViewDataSource

extension SortFilterVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: Constants.sortOptionCell, for: indexPath) as? SortOptionCell,
                let sortOption = tableData?[0].items[indexPath.row] as? SortFilterOptions.SortOption {
                cell.configureCell(labelText: sortOption.rawValue, isSelected: (sortOption == sortFilterOptions?.selectedSortOption))
                return cell
            }
        } else if indexPath.section == 1 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: Constants.filterOptionCell, for: indexPath) as? FilterOptionCell,
                let filterOption = tableData?[1].items[indexPath.row] as? SortFilterOptions.FilterOption {
                cell.configureCell(labelText: filterOption.rawValue)
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if let newSortOption = tableData?[0].items[indexPath.row] {
                sortFilterOptions?.selectedSortOption = newSortOption as! SortFilterOptions.SortOption
                tableView.reloadSections(IndexSet(integer: 0) , with: .none)
            }
        } else if indexPath.section == 1 {
            performSegue(withIdentifier: filterSegues[indexPath.row], sender: nil)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tableData?[section].title
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData?[section].items.count ?? 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableData?.count ?? 0
    }
}

// MARK: SortFilterVC+CarrierFilterVCDelegate

extension SortFilterVC: CarrierFilterVCDelegate {
    func carrierFilterVC(_ carrierFilterVC: CarrierFilterVC, setFilteredCarriersTo carriers: [FilterableCarrier]) {
        // TODO: Update filtered carriers
    }
}

