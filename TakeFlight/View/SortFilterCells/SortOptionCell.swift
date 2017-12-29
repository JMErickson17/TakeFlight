//
//  SortOptionCell.swift
//  TakeFlight
//
//  Created by Justin Erickson on 12/26/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import UIKit

class SortOptionCell: UITableViewCell {

    private lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private lazy var checkMarkImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        imageView.contentMode = .scaleAspectFit
        imageView.image = #imageLiteral(resourceName: "BlueCheckMark")
        imageView.isHidden = true
        return imageView
    }()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.setupView()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.setupView()
    }
    
    private func setupView() {
        addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        addSubview(checkMarkImage)
        NSLayoutConstraint.activate([
            checkMarkImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            checkMarkImage.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    func configureCell(labelText: String, isSelected: Bool) {
        label.text = labelText
        checkMarkImage.isHidden = !isSelected
    }

}
