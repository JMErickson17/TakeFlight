//
//  MyFlightCell.swift
//  TakeFlight
//
//  Created by Justin Erickson on 1/1/18.
//  Copyright © 2018 Justin Erickson. All rights reserved.
//

import UIKit

class MyFlightCell: UITableViewCell {
    
    private lazy var noFlightsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.text = "You don't have any upcoming flights.\nFind your next flight using the search tab."
        return label
    }()

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder: ) has not been implemented")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
    }

    private func setupView() {
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
        
        addSubview(noFlightsLabel)
        NSLayoutConstraint.activate([
            noFlightsLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            noFlightsLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
