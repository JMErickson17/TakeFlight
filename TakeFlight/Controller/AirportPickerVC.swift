//
//  AirportPickerVC.swift
//  TakeFlight
//
//  Created by Justin Erickson on 10/27/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import UIKit

class AirportPickerVC: UIViewController {
    
    // MARK: Properties
    
    @IBOutlet weak var backgroundView: UIView!
    
    private var tableView: UITableView!
    private var filteredResults: [String]!

    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupTableView()
    }

    // MARK: Setup
    
    func setupView() {
        let dismissTap = UITapGestureRecognizer(target: self, action: #selector(dismissViewController))
        backgroundView.addGestureRecognizer(dismissTap)
    }
    
    func setupTableView() {
        tableView = UITableView()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let screenSize: CGRect = UIScreen.main.bounds
        let tableViewWidth = Int(screenSize.width - 10)
        let tableViewHeight = 200
        
        tableView.frame = CGRect(x: 5, y: 90, width: tableViewWidth, height: tableViewHeight)
        tableView.layer.cornerRadius = 5
        
        tableView.register(UINib(nibName: Constants.AIRPORT_PICKER_CELL, bundle: nil), forCellReuseIdentifier: Constants.AIRPORT_PICKER_CELL)
        
        self.view.addSubview(tableView)
    }
    
    // MARK: Convenience
    
    @objc func dismissViewController() {
        dismiss(animated: true, completion: nil)
    }

}

// MARK: - UITableView

extension AirportPickerVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Constants.AIRPORT_PICKER_CELL, for: indexPath) as? AirportPickerCell {
            cell.configureCell(name: "This will be the name", location: "And this will be the location")
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
}
