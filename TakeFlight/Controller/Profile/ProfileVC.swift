//
//  ProfileVC.swift
//  TakeFlight
//
//  Created by Justin Erickson on 12/17/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController {
    
    // MARK: Properties
    
    @IBOutlet weak var myFlightsView: MyFlightsView!
    
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    // MARK: Setup
    
    private func setupView() {

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        myFlightsView.updateScrollViewContentSize()
    }
}
