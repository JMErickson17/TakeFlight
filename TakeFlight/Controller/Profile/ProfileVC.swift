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
    @IBOutlet weak var signOutButton: UIButton!
    
    private var authListener: NSObjectProtocol?
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        addAuthListener()
        updateViewForAuthChanges()
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
        authListener = NotificationCenter.default.addObserver(forName: .authStatusDidChange, object: nil, queue: OperationQueue.main, using: { _ in
            self.updateViewForAuthChanges()
        })
    }
    
    private func removeAuthListener() {
        if let authListener = authListener {
            NotificationCenter.default.removeObserver(authListener)
        }
    }
    
    private func updateViewForAuthChanges() {
        if let currentUser = UserDataService.instance.currentUser {
            self.configureView(forUser: currentUser)
        } else {
            self.configureViewForLoggedOut()
        }
    }
    
    private func configureView(forUser user: User) {
        userStatusView.isLoggedIn = true
        userStatusView.email = user.email
        signOutButton.isHidden = false
    }
    
    private func configureViewForLoggedOut() {
        userStatusView.isLoggedIn = false
        userStatusView.email = nil
        signOutButton.isHidden = true
    }
    
    private func signOutCurrentUser() {
        do {
            try UserDataService.instance.signOutCurrentUser()
            configureViewForLoggedOut()
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
