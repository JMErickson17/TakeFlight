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
        
        exploreTableView.delegate = self
        exploreTableView.dataSource = self
        exploreTableView.register(UINib(nibName: DestinationCell.reuseIdentifier,
                                      bundle: Bundle.main), forCellReuseIdentifier: DestinationCell.reuseIdentifier)
    }
    
    private func bindViewModel() {
        viewModel.tableData.asObservable().subscribe(onNext: { tableData in
            self.exploreTableView.reloadData()
        }).disposed(by: disposeBag)
    }
    
    // MARK: Convenience
    
    private func presentDestinationsVC(withDestinationsAt indexPath: IndexPath) {
        let destinations = viewModel.allItems(for: indexPath.section)
        let storyboard = UIStoryboard(name: "Explore", bundle: Bundle.main)
        
        if let destinationsVC = storyboard.instantiateViewController(withIdentifier: DestinationsVC.identifier) as? DestinationsVC {
            destinationsVC.destinationService = appDelegate.firebaseDestinationServive!
            destinationsVC.destinations = destinations
            destinationsVC.title = viewModel.title(for: indexPath.section)
            self.navigationController?.pushViewController(destinationsVC, animated: true)
        }
    }
    
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
}

// MARK: ExploreVC+UITableViewDelegate, UITableViewDataSource

extension ExploreVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: DestinationCell.reuseIdentifier, for: indexPath) as? DestinationCell {
            if indexPath.row == viewModel.trimmedItems(for: indexPath.section).count - 1 {
                cell.configureCell(with: "View More", image: #imageLiteral(resourceName: "SkyHeaderImage_3"))
                return cell
            }
            
            let destination = viewModel.destination(for: indexPath)
            cell.tag = indexPath.row
            viewModel.image(for: destination, completion: { image in
                guard cell.tag == indexPath.row else { return }
                cell.configureCell(with: destination, image: image)
            })
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.trimmedItems(for: indexPath.section).count - 1 {
            presentDestinationsVC(withDestinationsAt: indexPath)
        } else {
            searchDestination(at: indexPath)
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.title(for: section)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.tableData.value.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.tableData.value[section].items.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 175
    }
}
