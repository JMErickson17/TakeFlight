//
//  RefineVC.swift
//  TakeFlight
//
//  Created by Justin Erickson on 12/26/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import UIKit

class RefineVC: UIViewController {
    
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
        let items: [RefineOption]
    }
    
    enum PassengerOptionCell: RefineOption {
        case passengerOptionCell
    }
    
    // MARK: Properties
    
    @IBOutlet weak var tableView: UITableView!
    
    weak var delegate: RefineVCDelegate?
    
    var selectedSortOption: SortOption?
    var filterOptions: FlightFilterOptions?
    var carrierData: [CarrierData]?
    var passengerOptions: (adultCount: Int, childCount: Int, infantCount: Int)?
    
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
        tableView.register(UINib(nibName: "PassengerCell", bundle: nil), forCellReuseIdentifier: "PassengerCell")
        setupTableData()
        navigationItem.rightBarButtonItem = resetButton
    }
    
    private func setupTableData() {
        let sortOptions: [SortOption] = [.price, .duration, .takeoffTime, .landingTime]
        let filterOptions: [FilterOption] = [.airlines, .stops, .duration]
        let passengerOptions: [PassengerOptionCell] = [.passengerOptionCell]
        tableData = [
            Section(title: "Sort", items: sortOptions),
            Section(title: "Filter", items: filterOptions),
            Section(title: "Passengers", items: passengerOptions)
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
    
    private func makeCellDetailLabel(for filterOption: FilterOption) -> String? {
        switch filterOption {
        case .airlines:
            if let filteredCarriersCount = self.carrierData?.filter( { $0.isFiltered == true } ).count {
                return "Filtering \(filteredCarriersCount) \((filteredCarriersCount == 1 ? "Carrier" : "Carriers"))"
            }
        case .duration:
            if let duration = self.filterOptions?.maxDuration {
                let durationString = String(duration).capitalized
                return "\(durationString) Hours Max"
            }
        case .stops:
            if let stops = self.filterOptions?.maxStops {
                return "\(stops.description) Stops Max"
            }
        }
        return nil
    }
    
    @objc private func handleResetButtonTapped() {
        selectedSortOption = .price
        filterOptions?.resetFilters()
        resetCarrierFilters()
        tableView.reloadData()
        delegate?.refineVCDidResetSortAndFilter(self)
    }
    
    func resetCarrierFilters() {
        guard carrierData != nil else { return }
        
        for i in 0..<carrierData!.count {
            carrierData![i].isFiltered = false
        }
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource

extension RefineVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            if let cell = tableView.dequeueReusableCell(withIdentifier: Constants.sortOptionCell, for: indexPath) as? SortOptionCell {
                let option = tableData[0].items[indexPath.row] as! SortOption
                cell.configureCell(labelText: option.description, isSelected: option == selectedSortOption)
                return cell
            }
        case 1:
            if let cell = tableView.dequeueReusableCell(withIdentifier: Constants.filterOptionCell, for: indexPath) as? FilterOptionCell {
                let option = tableData[1].items[indexPath.row] as! FilterOption
                cell.configureCell(labelText: option.description, detailText: makeCellDetailLabel(for: option))
                return cell
            }
        case 2:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "PassengerCell", for: indexPath) as? PassengerCell {
                if let passengerOptions = passengerOptions {
                    cell.configureCell(withAdultCount: passengerOptions.adultCount, childCount: passengerOptions.childCount, infantCount: passengerOptions.infantCount)
                }
                cell.delegate = self
                return cell
            }
            
        default: break
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let newSortOption = tableData[0].items[indexPath.row] as! SortOption
            selectedSortOption = newSortOption
            delegate?.refineVC(self, sortOptionDidChangeTo: newSortOption)
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

// MARK:- CarrierFilterVCDelegate

extension RefineVC: CarrierFilterVCDelegate {
    func carrierFilterVC(_ carrierFilterVC: CarrierFilterVC, didUpdateCarrierData carrierData: CarrierData) {
        if let index = self.carrierData?.index(where: { $0.carrier == carrierData.carrier }) {
            guard self.carrierData != nil else { return }
            self.carrierData![index] = carrierData
            tableView.reloadRows(at: [IndexPath(row: 0, section: 1)], with: .top)
            delegate?.refineVC(self, carrierDataDidChangeTo: self.carrierData!)
        }
    }
}

// MARK:- StopFilterVCDelegate

extension RefineVC: StopFilterVCDelegate {
    func stopFilterVC(_ stopFilterVC: StopFilterVC, didUpdateMaxStopsTo maxStops: MaxStops) {
        filterOptions?.maxStops = maxStops
        tableView.reloadRows(at: [IndexPath(row: 1, section: 1)], with: .top)
        delegate?.refineVC(self, maxStopsDidChangeTo: maxStops)
    }
}

// MARK:- DurationFilterVCDelegate

extension RefineVC: DurationFilterVCDelegate {
    func durationFilterVC(_ durationFilterVC: DurationFilterVC, didUpdateMaxDurationTo maxDuration: Hour) {
        filterOptions?.maxDuration = maxDuration
        tableView.reloadRows(at: [IndexPath(row: 2, section: 1)], with: .top)
        delegate?.refineVC(self, maxDurationDidChangeTo: maxDuration)
    }
}

// MARK:- PassengerCellDelegate

extension RefineVC: PassengerCellDelegate {
    func passengerCell(_ passengerCell: PassengerCell, didUpdate option: PassengerOption) {
        switch option {
        case .adultPassengers(let value):
            self.passengerOptions?.adultCount = value
        case .childPassengers(let value):
            self.passengerOptions?.childCount = value
        case .infantPassengers(let value):
            self.passengerOptions?.infantCount = value
        }
        delegate?.refineVC(self, didUpdate: option)
    }
}
