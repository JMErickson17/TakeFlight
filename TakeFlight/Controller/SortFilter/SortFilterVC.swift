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
    
    var selectedSortOption: SortOption?
    var filterOptions: FlightFilterOptions?
    var carrierData: [CarrierData]?
    
    private var tableData: [Section]!
    
    private let filterSegues = [Constants.toCarrierFilterVC, Constants.toStopFilterVC, Constants.toDurationFilterVC]
    
    private lazy var resetButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.title = "Reset"
        button.target = self
        button.action = #selector(handleResetButtonTapped)
        return button
    }()
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupView()
    }
    
    // MARK: Setup

    private func setupView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SortOptionCell.self, forCellReuseIdentifier: Constants.sortOptionCell)
        tableView.register(FilterOptionCell.self, forCellReuseIdentifier: Constants.filterOptionCell)
        setupTableData()
        navigationItem.rightBarButtonItem = resetButton
    }
    
    private func setupTableData() {
        let sortOptions: [SortOption] = [.price, .duration, .takeoffTime, .landingTime]
        let filterOptions: [FilterOption] = [.airlines, .stops, .duration]
        tableData = [
            Section(title: "Sort", items: sortOptions),
            Section(title: "Filter", items: filterOptions)
        ]
    }

    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
        case Constants.toCarrierFilterVC:
            if let destination = segue.destination as? CarrierFilterVC {
                destination.delegate = self
                destination.carrierData = carrierData
            }
        case Constants.toStopFilterVC:
            if let destination = segue.destination as? StopFilterVC {
                destination.delegate = self
                destination.selectedMaxStops = filterOptions?.maxStops
            }
        case Constants.toDurationFilterVC:
            if let destination = segue.destination as? DurationFilterVC {
                destination.delegate = self
                destination.selectedMaxDuration = filterOptions?.maxDuration
            }
        default: break
            
        }
    }
    
    // MARK: Convenience
    
    @objc private func handleResetButtonTapped() {
        selectedSortOption = .price
        filterOptions?.resetFilters()
        resetCarrierFilters()
        tableView.reloadData()
        delegate?.sortFilterVCDidResetSortAndFilter(self)
    }
    
    func resetCarrierFilters() {
        guard carrierData != nil else { return }
        
        for i in 0..<carrierData!.count {
            carrierData![i].isFiltered = false
        }
    }
}

// MARK: - SortFilterVC+UITableViewDelegate & UITableViewDataSource

extension SortFilterVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: Constants.sortOptionCell, for: indexPath) as? SortOptionCell {
                let option = tableData[0].items[indexPath.row] as! SortOption
                cell.configureCell(labelText: option.description, isSelected: option == selectedSortOption)
                return cell
            }
        } else if indexPath.section == 1 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: Constants.filterOptionCell, for: indexPath) as? FilterOptionCell {
                let option = tableData[1].items[indexPath.row] as! FilterOption
                cell.configureCell(labelText: option.description, detailText: "")
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let newSortOption = tableData[0].items[indexPath.row] as! SortOption
            selectedSortOption = newSortOption
            delegate?.sortFilterVC(self, sortOptionDidChangeTo: newSortOption)
            tableView.reloadData()
        } else if indexPath.section == 1 {
            performSegue(withIdentifier: filterSegues[indexPath.row], sender: nil)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tableData[section].title
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData[section].items.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableData.count
    }
}

// MARK:- SortFilterVC+CarrierFilterVCDelegate

extension SortFilterVC: CarrierFilterVCDelegate {
    func carrierFilterVC(_ carrierFilterVC: CarrierFilterVC, didUpdateCarrierData carrierData: CarrierData) {
        if let index = self.carrierData?.index(where: { $0.carrier == carrierData.carrier }) {
            guard self.carrierData != nil else { return }
            self.carrierData![index] = carrierData
            delegate?.sortFilterVC(self, carrierDataDidChangeTo: self.carrierData!)
        }
    }
}

// MARK:- SortFilterVC+StopFilterVCDelegate

extension SortFilterVC: StopFilterVCDelegate {
    func stopFilterVC(_ stopFilterVC: StopFilterVC, didUpdateMaxStopsTo maxStops: MaxStops) {
        filterOptions?.maxStops = maxStops
        tableView.reloadRows(at: [IndexPath(row: 1, section: 1)], with: .top)
        delegate?.sortFilterVC(self, maxStopsDidChangeTo: maxStops)
    }
}

// MARK:- SortFilterVC+DurationFilterVCDelegate

extension SortFilterVC: DurationFilterVCDelegate {
    func durationFilterVC(_ durationFilterVC: DurationFilterVC, didUpdateMaxDurationTo maxDuration: Hour) {
        filterOptions?.maxDuration = maxDuration
        tableView.reloadRows(at: [IndexPath(row: 2, section: 1)], with: .top)
        delegate?.sortFilterVC(self, maxDurationDidChangeTo: maxDuration)
    }
}

