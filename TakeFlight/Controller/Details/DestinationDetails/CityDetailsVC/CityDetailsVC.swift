//
//  CityDetailsVC.swift
//  TakeFlight
//
//  Created by Justin Erickson on 2/20/18.
//  Copyright © 2018 Justin Erickson. All rights reserved.
//

import UIKit

class CityDetailsVC: UIViewController {
    
    // MARK: Properties
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    var destination: Destination? {
        didSet {
            if let destination = destination {
                self.configureView(for: destination)
            }
        }
    }
    
    private let populationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    // MARK: View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    // MARK: Setup

    private func setupView() {
        view.addSubview(populationLabel)
        NSLayoutConstraint.activate([
            populationLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            populationLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    
    private func configureView(for destination: Destination) {
        populationLabel.text = "Population: \(destination.population)"
    }

}


