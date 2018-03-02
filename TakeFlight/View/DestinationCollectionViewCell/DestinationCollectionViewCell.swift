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
    
    weak var delegate: DestinationCollectionViewCellDelegate?
    
    private var destination: Destination?
    
    private lazy var backgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.image = #imageLiteral(resourceName: "DefaultDestinationImage")
        return imageView
    }()
    
    private lazy var destinationDetailsButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "CityInfoIcon"), for: .normal)
        button.addTarget(self, action: #selector(destinationDetailsButtonWasTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var blurredView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let view = UIVisualEffectView(effect: blurEffect)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var vibrantView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let vibrantEffect = UIVibrancyEffect(blurEffect: blurEffect)
        let view = UIVisualEffectView(effect: vibrantEffect)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var title: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .white
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
        
        addSubview(destinationDetailsButton)
        NSLayoutConstraint.activate([
            destinationDetailsButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            destinationDetailsButton.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            destinationDetailsButton.heightAnchor.constraint(equalToConstant: 50),
            destinationDetailsButton.widthAnchor.constraint(equalToConstant: 50)
        ])
        
        addSubview(blurredView)
        NSLayoutConstraint.activate([
            blurredView.leadingAnchor.constraint(equalTo: leadingAnchor),
            blurredView.trailingAnchor.constraint(equalTo: trailingAnchor),
            blurredView.bottomAnchor.constraint(equalTo: bottomAnchor),
            blurredView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.15)
        ])
        
        blurredView.contentView.addSubview(vibrantView)
        NSLayoutConstraint.activate([
            vibrantView.leadingAnchor.constraint(equalTo: blurredView.contentView.leadingAnchor),
            vibrantView.topAnchor.constraint(equalTo: blurredView.contentView.topAnchor),
            vibrantView.trailingAnchor.constraint(equalTo: blurredView.contentView.trailingAnchor),
            vibrantView.bottomAnchor.constraint(equalTo: blurredView.contentView.bottomAnchor),
        ])
        
        addSubview(title)
        NSLayoutConstraint.activate([
            title.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            title.centerYAnchor.constraint(equalTo: blurredView.centerYAnchor)
        ])
    }
    
    // MARK: Convenience
    
    func configureCell(with image: UIImage?, destination: Destination) {
        self.destination = destination
        if let image = image {
            self.backgroundImage.image = image
        }
        self.title.text = [destination.city, destination.state].joined(separator: ", ")
    }
    
    @objc private func destinationDetailsButtonWasTapped(_ sender: UIButton) {
        guard let destination = destination else { return }
        delegate?.destinationCollectionViewCell(self, didSelectDestinationDetailsFor: destination)
    }
}

