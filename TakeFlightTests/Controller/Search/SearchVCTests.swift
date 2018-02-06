//
//  SearchVCTests.swift
//  TakeFlightTests
//
//  Created by Justin Erickson on 2/6/18.
//  Copyright © 2018 Justin Erickson. All rights reserved.
//

import UIKit
import RxSwift
import XCTest
import Quick
import Nimble
@testable import TakeFlight

class SearchVCTests: XCTestCase {
    
    var searchVC: SearchVC!
    
    override func setUp() {
        super.setUp()
        
        let storyboard = UIStoryboard(name: "Search", bundle: nil)
        searchVC = storyboard.instantiateViewController(withIdentifier: "SearchVC") as! SearchVC
    }
    
    func testClearLocations_clearsTextFields() {
        let _ = searchVC.view
        searchVC.clearLocations()
        
        let originText = searchVC.originTextField.text
        let destinationText = searchVC.destinationTextField.text
        
        expect(originText).to(equal(""))
        expect(destinationText).to(equal(""))
    }
    
    func testClearDates_clearsTextFields() {
        let _ = searchVC.view
        searchVC.clearDates()
        
        let departureText = searchVC.departureDateTextField.text
        let returnText = searchVC.returnDateTextField.text
        
        expect(departureText).to(equal(""))
        expect(returnText).to(equal(""))
    }
}
