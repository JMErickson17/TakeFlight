//
//  DestinationMapVC.swift
//  TakeFlight
//
//  Created by Justin Erickson on 2/21/18.
//  Copyright © 2018 Justin Erickson. All rights reserved.
//

import UIKit
import MapKit

class DestinationMapVC: UIViewController {

    // MARK: Properties
    
    private var destination: Destination!
    
    private let mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    convenience init(destination: Destination) {
        self.init()
        
        self.destination = destination
    }

    private func setupView() {
        view.addSubview(mapView)
        NSLayoutConstraint.activate([
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func configureView(for destination: Destination) {
        
    }
}

