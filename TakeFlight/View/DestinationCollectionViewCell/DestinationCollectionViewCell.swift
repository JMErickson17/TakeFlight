//
//  DestinationCollectionViewCell.swift
//  TakeFlight
//
//  Created by Justin Erickson on 2/17/18.
//  Copyright © 2018 Justin Erickson. All rights reserved.
//

import UIKit

class DestinationCollectionViewCell: UICollectionViewCell {
    
    // MARK: Properties
    
    private lazy var backgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.image = #imageLiteral(resourceName: "DefaultDestinationImage")
        return imageView
    }()
    
    private lazy var blurredView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let view = UIVisualEffectView(effect: blurEffect)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var title: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.numberOfLines = 2
        return label
    }()
    
    // MARK: View Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder: ) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    // MARK: Setup
    
    private func setupView() {
        clipsToBounds = true
        layer.cornerRadius = 5
        
        addSubview(backgroundImage)
        NSLayoutConstraint.activate([
            backgroundImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundImage.topAnchor.constraint(equalTo: topAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        addSubview(blurredView)
        NSLayoutConstraint.activate([
            blurredView.leadingAnchor.constraint(equalTo: leadingAnchor),
            blurredView.trailingAnchor.constraint(equalTo: trailingAnchor),
            blurredView.bottomAnchor.constraint(equalTo: bottomAnchor),
            blurredView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.25)
        ])
        
        blurredView.contentView.addSubview(title)
        NSLayoutConstraint.activate([
            title.leadingAnchor.constraint(equalTo: blurredView.contentView.leadingAnchor, constant: 8),
            title.centerYAnchor.constraint(equalTo: blurredView.contentView.centerYAnchor)
        ])
    }
    
    // MARK: Convenience
    
    func configureCell(with image: UIImage?, title: String, subtitle: String) {
        if let image = image {
            self.backgroundImage.image = image
        }
        self.title.text = [title, subtitle].joined(separator: "\n")
    }
}

