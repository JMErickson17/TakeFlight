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
    
    var selectedSortOption: SortOptions.Option?
    var filterOptions: FilterOptions?
    var currentCarriers: [Carrier]?
    
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
        let sortOptions: [SortOptions.Option] = [.price, .duration, .takeoffTime, .landingTime]
        let filterOptions: [FilterOptions.Option] = [.airlines, .stops, .duration]
        tableData = [
            Section(title: "Sort", items: sortOptions),
            Section(title: "Filter", items: filterOptions)
        ]
    }
    
    private func filterOptionDetails(for option: FilterOptions.Option) -> String? {
        switch option {
        case .airlines:
            if let activeFilters = filterOptions?.activeCarrierFilters { guard activeFilters.count > 0 else { return nil } }
            if let nonFilteredCarriers = filterOptions?.filteredCarriers?.filter({ $0.isFiltered == false }) {
                return nonFilteredCarriers.map({ $0.carrier.name.capitalized }).joined(separator: ", ")
            }
        case .stops:
            if let stops = filterOptions?.maxStops {
                return "\(stops.rawValue) Stops Max"
            }
        case .duration:
            if let duration = filterOptions?.maxDuration {
                let durationString = String(duration).capitalized
                return "\(durationString) Hours Max"
            }
        }
        return nil
    }
    
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
        case Constants.toCarrierFilterVC:
            if let destination = segue.destination as? CarrierFilterVC {
                destination.delegate = self
                destination.filteredCarriers = filterOptions?.filteredCarriers
                destination.carriersInCurrentSearch = currentCarriers?.map { FilterableCarrier(carrier: $0) }
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
        delegate?.sortFilterVC(self, sortOptionDidChangeTo: selectedSortOption!)
        delegate?.sortFilterVC(self, filterOptionsDidChangeTo: filterOptions)
        tableView.reloadData()
    }
}

// MARK: - SortFilterVC+UITableViewDelegate & UITableViewDataSource

extension SortFilterVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: Constants.sortOptionCell, for: indexPath) as? SortOptionCell {
                let option = tableData[0].items[indexPath.row] as! SortOptions.Option
                cell.configureCell(labelText: option.rawValue, isSelected: option == selectedSortOption)
                return cell
            }
        } else if indexPath.section == 1 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: Constants.filterOptionCell, for: indexPath) as? FilterOptionCell {
                let option = tableData[1].items[indexPath.row] as! FilterOptions.Option
                cell.configureCell(labelText: option.rawValue, detailText: filterOptionDetails(for: option))
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let newSortOption = tableData[0].items[indexPath.row] as! SortOptions.Option
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
    func carrierFilterVC(_ carrierFilterVC: CarrierFilterVC, didUpdateCarrier carrier: FilterableCarrier) {
        filterOptions?.update(carrier)
        tableView.reloadRows(at: [IndexPath(row: 0, section: 1)], with: .top)
        delegate?.sortFilterVC(self, filterOptionsDidChangeTo: filterOptions)
    }
}

// MARK:- SortFilterVC+StopFilterVCDelegate

extension SortFilterVC: StopFilterVCDelegate {
    func stopFilterVC(_ stopFilterVC: StopFilterVC, didUpdateMaxStopsTo maxStops: MaxStops) {
        filterOptions?.update(maxStops)
        tableView.reloadRows(at: [IndexPath(row: 1, section: 1)], with: .top)
        delegate?.sortFilterVC(self, filterOptionsDidChangeTo: filterOptions)
    }
}

// MARK:- SortFilterVC+DurationFilterVCDelegate

extension SortFilterVC: DurationFilterVCDelegate {
    func durationFilterVC(_ durationFilterVC: DurationFilterVC, didUpdateMaxDurationTo maxDuration: Hour) {
        filterOptions?.update(maxDuration)
        tableView.reloadRows(at: [IndexPath(row: 2, section: 1)], with: .top)
        delegate?.sortFilterVC(self, filterOptionsDidChangeTo: filterOptions)
    }
}

