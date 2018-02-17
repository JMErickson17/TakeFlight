//
//  ExploreVC.swift
//  TakeFlight
//
//  Created by Justin Erickson on 12/17/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import UIKit
import Firebase
import RxSwift
import RxCocoa

class ExploreVC: UIViewController {
    
    // MARK: Properties
    
    @IBOutlet weak var exploreTableView: UITableView!
    
    private var viewModel: ExploreViewModel!
    private var airportService: AirportService!
    private var disposeBag = DisposeBag()
    
    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        bindViewModel()
    }
    
    // MARK: Setup
    
    private func setupView() {
        self.viewModel = ExploreViewModel(destinationService: appDelegate.firebaseDestinationServive!)
        self.airportService = appDelegate.firebaseAirportService!
        
        exploreTableView.delegate = self
        exploreTableView.dataSource = self
        exploreTableView.registerReusableCell(DestinationCollectionCell.self)
    }
    
    private func bindViewModel() {
        viewModel.tableData.asObservable().subscribe(onNext: { tableData in
            self.exploreTableView.reloadData()
        }).disposed(by: disposeBag)
    }
    
    // MARK: Convenience
    
    private func searchDestination(at indexPath: IndexPath) {
        let destinationAirportCode = viewModel.destination(for: indexPath).airports.first!
        let destinationAirport = appDelegate.firebaseAirportService!.airport(withIdentifier: destinationAirportCode)
        UserDefaultsService.instance.destination = destinationAirport!
        
        self.tabBarController?.selectTab(1, animated: true, completion: {
            if let navigationController = self.tabBarController?.selectedViewController as? UINavigationController {
                if let searchVC = navigationController.topViewController as? SearchVC {
                    searchVC.updateUserDefaultsAndSearch()
                }
            }
        })
    }
    
    private func search(_ destination: Destination) {
        guard let identifier = destination.airports.first else { return }
        if let airport = airportService.airport(withIdentifier: identifier) {
            UserDefaultsService.instance.destination = airport
            
            self.tabBarController?.selectTab(1, animated: true) {
                if let navigationController = self.tabBarController?.selectedViewController as? UINavigationController {
                    if let searchVC = navigationController.topViewController as? SearchVC {
                        searchVC.updateUserDefaultsAndSearch()
                    }
                }
            }
        }
    }
}

// MARK: ExploreVC+UITableViewDelegate, UITableViewDataSource

extension ExploreVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.deqeueReusableCell(indexPath: indexPath) as DestinationCollectionCell
        let items = viewModel.items(for: indexPath.section)
        let contentManager = DestinationCollectionCellManager(destinations: items, destinationService: appDelegate.firebaseDestinationServive!)
        cell.contentManager = contentManager
        cell.contentManager?.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.title(for: section)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.tableData.value.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}

// MARK:- DestinationCollectionCellManagerDelegate

extension ExploreVC: DestinationCollectionCellManagerDelegate {
    func destinationCollectionCellManager(_ destinationCollectionCellManager: DestinationCollectionCellManager, didSelectDestination destination: Destination) {
        search(destination)
    }
}
