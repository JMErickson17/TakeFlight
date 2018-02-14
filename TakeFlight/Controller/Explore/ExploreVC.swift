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
    
    private lazy var originTextField: UITextField = {
        let textField = UITextField()
        return textField
    }()
    
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
    }
    
    private func bindViewModel() {
        viewModel.tableData.asObservable().subscribe(onNext: { tableData in
            self.exploreTableView.reloadData()
        }).disposed(by: disposeBag)
    }
}

// MARK: ExploreVC+UITableViewDelegate, UITableViewDataSource

extension ExploreVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: DestinationCell.reuseIdentifier, for: indexPath) as? DestinationCell {
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
        let destinationAirportCode = viewModel.destination(for: indexPath).airports.first!
        let destinationAirport = appDelegate.firebaseAirportService!.airport(withIdentifier: destinationAirportCode)
        UserDefaultsService.instance.destination = destinationAirport!
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
