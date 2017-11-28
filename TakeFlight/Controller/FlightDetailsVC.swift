//
//  FlightDetailsVC.swift
//  TakeFlight
//
//  Created by Justin Erickson on 11/13/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import UIKit

class FlightDetailsVC: UIViewController, UIScrollViewDelegate {
    
    // MARK: Properties
    
    //private let flightData: FlightDataContainer?
    
    private lazy var scrollView: UIScrollView = {
        var scrollView = UIScrollView()
        scrollView.isScrollEnabled = true
        scrollView.isPagingEnabled = false
        scrollView.showsVerticalScrollIndicator = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 1.0
        return scrollView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupScrollView()
    }
    
    private func setupView() {
        view.backgroundColor = .white
    }
    
    private func setupScrollView() {
        scrollView.delegate = self
        
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        scrollView.backgroundColor = .blue
        scrollView.contentSize = CGSize(width: view.bounds.width, height: 1000)
    }

}
