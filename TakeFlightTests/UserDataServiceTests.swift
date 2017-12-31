//
//  UserDataServiceTests.swift
//  TakeFlightTests
//
//  Created by Justin Erickson on 12/30/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import XCTest
import Firebase
@testable import TakeFlight

class UserDataServiceTests: XCTestCase {
    
    let email = "TestEmail@XCTesting.com"
    let validPassword = "ValidPassword"
    
    func testCreateNewUser() {
        let createNewUserExpectation = expectation(description: "UserDataService should create and return a new user using Firebase Auth")
        
        UserDataService.instance.createNewUser(withEmail: email, password: validPassword) { (user, error) in
            XCTAssertNotNil(user, "The returned user is nil")
            XCTAssertNil(error, "There was an error creating the user: \(String(describing: error))")
            createNewUserExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 3) { error in
            if let error = error {
                XCTFail("createNewUserExpectation failed: \(error)")
            }
        }
    }
    
    func testSignInUser() {
        let signInUserExpectation = expectation(description: "UserDataService should sign in the test user")
        
        UserDataService.instance.signInUser(withEmail: email, password: validPassword) { (user, error) in
            XCTAssertNotNil(user, "The returned user is nil")
            XCTAssertNil(error, "There was an error signing in the user: \(String(describing: error))")
            XCTAssertEqual(user!.email, self.email.lowercased(), "The returned users email is incorrect")
            
            signInUserExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 3) { error in
            if let error = error {
                XCTFail("signInUserExpectation failed: \(error)")
            }
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
