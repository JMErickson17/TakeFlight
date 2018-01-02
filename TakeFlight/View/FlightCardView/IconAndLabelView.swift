//
//  IconAndLabelView.swift
//  TakeFlight
//
//  Created by Justin Erickson on 12/14/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import UIKit

class IconAndLabelView: UIView {
    
    // MARK: Properties
    
    var imageSize: CGFloat = 20 {
        didSet {
            layoutIfNeeded()
        }
    }
    
    var image: UIImage? {
        didSet {
            imageView.image = image
            layoutIfNeeded()
        }
    }
    
    var text: String? {
        didSet {
            label.text = text
            layoutIfNeeded()
        }
    }

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.light)
        label.textColor = UIColor.white
        return label
    }()
    
    // MARK: Lifecycle

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implmented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupView()
    }
    
    // MARK: Setup
    
    private func setupView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageView.widthAnchor.constraint(equalToConstant: imageSize),
            imageView.heightAnchor.constraint(equalToConstant: imageSize)
        ])
        
        self.addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 5),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            label.centerYAnchor.constraint(equalTo: imageView.centerYAnchor)
        ])
    }
}
