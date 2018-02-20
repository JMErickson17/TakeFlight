//
//  DestinationDetailsVC.swift
//  TakeFlight
//
//  Created by Justin Erickson on 2/17/18.
//  Copyright © 2018 Justin Erickson. All rights reserved.
//

import UIKit

class DestinationDetailsVC: UIViewController {

    // MARK: Properties
    
    private var destinationService: DestinationService!
    
    var destination: Destination? {
        didSet {
            if let destination = destination {
                configureView(for: destination)
            }
        }
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    private lazy var destinationImageHeader: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = #imageLiteral(resourceName: "SkyHeaderImage_2")
        return imageView
    }()
    
    private lazy var destinationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 24)
        label.textColor = .white
        return label
    }()
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupTableView()
    }
    
    // MARK: Initialization
    
    convenience init(destination: Destination) {
        self.init()
        
        self.destinationService = appDelegate.firebaseDestinationServive!
        self.destination = destination
        configureView(for: destination)
    }

    // MARK: Setup
    
    private func setupView() {
        destinationImageHeader.addSubview(destinationLabel)
        NSLayoutConstraint.activate([
            destinationLabel.leadingAnchor.constraint(equalTo: destinationImageHeader.leadingAnchor, constant: 8),
            destinationLabel.bottomAnchor.constraint(equalTo: destinationImageHeader.bottomAnchor, constant: -8)
        ])
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        tableView.tableHeaderView = destinationImageHeader
        tableView.contentInset = UIEdgeInsets(top: destinationImageHeader.frame.height, left: 0, bottom: 0, right: 0)
    }
    
    // MARK: Configuration
    
    private func configureView(for destination: Destination) {
        destinationLabel.text = destination.city
        
        destinationService.image(for: destination) { [weak self] image, error in
            if let error = error { print(error) }
            DispatchQueue.main.async {
                self?.destinationImageHeader.image = image
            }
        }
    }
}

// MARK:- UITableViewDelegate, UITableViewDataSource

extension DestinationDetailsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    
}
