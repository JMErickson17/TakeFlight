//
//  ProfileVC.swift
//  TakeFlight
//
//  Created by Justin Erickson on 12/17/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import UIKit
import FirebaseAuth

class ProfileVC: UIViewController {
    
    private struct Constants {
        static let toLoginVC = "ToLoginVC"
        static let toSignupVC = "ToSignupVC"
    }
    
    // MARK: Properties
    
    @IBOutlet weak var userStatusView: LoggedInStatusView!
    
    private var handleAuthStateDidChange: AuthStateDidChangeListenerHandle?
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        addAuthListener()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        removeAuthListener()
    }
    
    // MARK: Setup
    
    private func setupView() {
        userStatusView.delegate = self
    }
    
    // MARK: Actions
    
    @IBAction func signOutButtonTapped(_ sender: UIButton) {
        signOutCurrentUser()
    }
    
    // MARK: Convenience
    
    private func addAuthListener() {
        handleAuthStateDidChange = Auth.auth().addStateDidChangeListener({ (auth, user) in
            if let user = user {
                self.configureView(forUser: user)
            }
        })
    }
    
    private func removeAuthListener() {
        Auth.auth().removeStateDidChangeListener(handleAuthStateDidChange!)
    }
    
    private func configureView(forUser user: User?) {
        if let user = user {
            userStatusView.isLoggedIn = true
            userStatusView.email = user.email
        } else {
            userStatusView.isLoggedIn = false
            userStatusView.email = nil
        }
    }
    
    private func signOutCurrentUser() {
        do {
            try FirebaseDataService.instance.signOutCurrentUser()
            configureView(forUser: nil)
        } catch {
            print(error)
        }
    }
}

// MARK:- LoggedInStatusViewDelegate

extension ProfileVC: LoggedInStatusViewDelegate {
    
    func loggedInStatusView(_ loggedInStatusView: LoggedInStatusView, loginButtonWasTapped: Bool) {
        performSegue(withIdentifier: Constants.toLoginVC, sender: nil)
    }
    
    func loggedInStatusView(_ loggedInStatusView: LoggedInStatusView, signupButtonWasTapped: Bool) {
        performSegue(withIdentifier: Constants.toSignupVC, sender: nil)
    }
}
