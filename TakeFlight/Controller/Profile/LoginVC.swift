//
//  LoginVC.swift
//  TakeFlight
//
//  Created by Justin Erickson on 12/19/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginVC: UIViewController {
    
    // MARK: Properties
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var forgotPasswordLabel: UILabel!
    @IBOutlet weak var activitySpinner: UIActivityIndicatorView!
    
    private var email: String? {
        if emailTextField.text != "" {
            return emailTextField.text
        }
        return nil
    }
    
    private var password: String? {
        if passwordTextField.text != "" {
            return passwordTextField.text
        }
        return nil
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // MARK: Actions

    @IBAction func loginButtonWasTapped(_ sender: OutlineButton) {
        activitySpinner.startAnimating()
        loginUser()
    }
    
    // MARK: Convenience
    
    private func loginUser() {
        if let email = email, let password = password {
            UserDataService.instance.signInUser(withEmail: email, password: password, completion: { [weak self] (user, error) in
                self?.activitySpinner.stopAnimating()
                if let error = error {
                    if let navigationController = self?.navigationController {
                        let notification = DropDownNotification(text: error.localizedDescription)
                        notification.presentNotification(onNavigationController: navigationController, forDuration: 3)
                    }
                    return
                }
                self?.navigationController?.popToRootViewController(animated: true)
            })
        }
        activitySpinner.stopAnimating()
    }
}
