//
//  DestinationCell.swift
//  TakeFlight
//
//  Created by Justin Erickson on 1/30/18.
//  Copyright © 2018 Justin Erickson. All rights reserved.
//

import UIKit

class DestinationCell: UITableViewCell {
    
    // MARK: Properties
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var locationDetailLabel: UILabel!
    @IBOutlet weak var labelStackView: UIStackView!
    
    private lazy var viewMoreLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20)
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowRadius = 3
        label.layer.shadowOpacity = 1.0
        label.layer.shadowOffset = CGSize(width: 2, height: 2)
        label.layer.masksToBounds = false
        return label
    }()
    
    // MARK: Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupView()
    }
    
    private func setupView() {
        backgroundImage.layer.cornerRadius = 5
        
        locationLabel.layer.shadowColor = UIColor.black.cgColor
        locationLabel.layer.shadowRadius = 3
        locationLabel.layer.shadowOpacity = 1.0
        locationLabel.layer.shadowOffset = CGSize(width: 2, height: 2)
        locationLabel.layer.masksToBounds = false
        
        locationDetailLabel.layer.shadowColor = UIColor.black.cgColor
        locationDetailLabel.layer.shadowRadius = 3
        locationDetailLabel.layer.shadowOpacity = 1.0
        locationDetailLabel.layer.shadowOffset = CGSize(width: 2, height: 2)
        locationDetailLabel.layer.masksToBounds = false
    }

    func configureCell(with destination: Destination, image: UIImage?) {
        self.locationLabel.text = "\(destination.city), \(destination.state)"
        self.locationDetailLabel.text = destination.country
        self.viewMoreLabel.isHidden = true
        if let image = image {
            self.backgroundImage.image = image
        }
    }
    
    func configureCell(with text: String, image: UIImage) {
        self.locationLabel.text = ""
        self.locationDetailLabel.text = ""
        self.backgroundImage.image = image
        self.viewMoreLabel.text = text
        self.viewMoreLabel.isHidden = false
        
        addSubview(viewMoreLabel)
        NSLayoutConstraint.activate([
            viewMoreLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            viewMoreLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

}
