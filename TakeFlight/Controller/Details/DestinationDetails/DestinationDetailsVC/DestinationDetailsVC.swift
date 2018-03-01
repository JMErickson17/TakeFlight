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
    
    private let scrollView: UIScrollView  = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .white
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let destinationHeaderView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let destinationHeaderImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let destinationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 24)
        label.textColor = .white
        return label
    }()
    
    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        return stackView
    }()
    
    private let cityDetailsVC: CityDetailsVC = {
        let cityDetailsVC = CityDetailsVC()
        cityDetailsVC.view.translatesAutoresizingMaskIntoConstraints = false
        cityDetailsVC.view.backgroundColor = .white
        return cityDetailsVC
    }()
    
    private lazy var destinationFlightsVC: DestinationFlightsVC = {
        let destinationFlightsVC = DestinationFlightsVC(destination: self.destination!)
        destinationFlightsVC.view.translatesAutoresizingMaskIntoConstraints = false
        destinationFlightsVC.view.backgroundColor = .white
        return destinationFlightsVC
    }()
    
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
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
        view.backgroundColor = .white
        
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        scrollView.addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
        
        destinationHeaderView.addSubview(destinationHeaderImage)
        NSLayoutConstraint.activate([
            destinationHeaderImage.leadingAnchor.constraint(equalTo: destinationHeaderView.leadingAnchor),
            destinationHeaderImage.topAnchor.constraint(equalTo: destinationHeaderView.topAnchor),
            destinationHeaderImage.trailingAnchor.constraint(equalTo: destinationHeaderView.trailingAnchor),
            destinationHeaderImage.bottomAnchor.constraint(equalTo: destinationHeaderView.bottomAnchor)
        ])
        
        
        destinationHeaderView.addSubview(destinationLabel)
        NSLayoutConstraint.activate([
            destinationLabel.leadingAnchor.constraint(equalTo: destinationHeaderView.leadingAnchor, constant: 8),
            destinationLabel.bottomAnchor.constraint(equalTo: destinationHeaderView.bottomAnchor, constant: -8)
        ])
        
        contentView.addSubview(destinationHeaderView)
        NSLayoutConstraint.activate([
            destinationHeaderView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            destinationHeaderView.topAnchor.constraint(equalTo: contentView.topAnchor),
            destinationHeaderView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            destinationHeaderView.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            destinationHeaderView.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.80)
        ])
        
        contentView.addSubview(contentStackView)
        NSLayoutConstraint.activate([
            contentStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentStackView.topAnchor.constraint(equalTo: destinationHeaderView.bottomAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        add(cityDetailsVC)
        contentStackView.addArrangedSubview(cityDetailsVC.view)
        cityDetailsVC.destination = destination
        NSLayoutConstraint.activate([
            cityDetailsVC.view.widthAnchor.constraint(equalTo: contentStackView.widthAnchor),
            cityDetailsVC.view.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        add(destinationFlightsVC)
        contentStackView.addArrangedSubview(destinationFlightsVC.view)
        NSLayoutConstraint.activate([
            destinationFlightsVC.view.widthAnchor.constraint(equalTo: contentStackView.widthAnchor),
            destinationFlightsVC.view.heightAnchor.constraint(equalToConstant: 500)
        ])
        
        scrollView.contentSize = CGSize(width: contentView.bounds.width, height: contentView.bounds.height)
    }
    
    
    // MARK: Configuration
    
    private func configureView(for destination: Destination) {
        destinationLabel.text = destination.city
        
        destinationService.image(for: destination) { [weak self] image, error in
            if let error = error { print(error) }
            DispatchQueue.main.async {
                self?.destinationHeaderImage.image = image
            }
        }
    }
}

