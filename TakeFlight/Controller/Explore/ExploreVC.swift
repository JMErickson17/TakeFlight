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
    
    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    // MARK: Setup
    
    private func setupView() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let destinationService = FirebaseDestinationService(database: Firestore.firestore(), storageService: appDelegate.firebaseStorage!)
        self.viewModel = ExploreViewModel(destinationService: destinationService)
        
        exploreTableView.delegate = self
        exploreTableView.dataSource = self
    }
}

// MARK: ExploreVC+UITableViewDelegate, UITableViewDataSource

extension ExploreVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "DestinationCell", for: indexPath) as? DestinationCell {
            let destination = viewModel.popularDestinations[indexPath.row]
            let image = UIImage(named: destination.city)!
            cell.configureCell(with: destination, image: image)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let airportService = appDelegate.firebaseAirportService!
        let destinationAirportCode = viewModel.popularDestinations[indexPath.row].airports.first!
        let destinationAirport = airportService.airport(withIdentifier: destinationAirportCode)
        let userDefaults = UserDefaultsService.instance
        userDefaults.destination = destinationAirport!
        tableView.deselectRow(at: indexPath, animated: true)
        self.tabBarController?.selectTab(1, animated: true, completion: {
            if let navigationController = self.tabBarController?.selectedViewController as? UINavigationController {
                if let searchVC = navigationController.topViewController as? SearchVC {
                    searchVC.updateUserDefaultsAndSearch()
                }
            }
        })
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Popular Destinations"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.popularDestinations.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 175
    }
}
