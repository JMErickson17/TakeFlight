//
//  SignupVC.swift
//  TakeFlight
//
//  Created by Justin Erickson on 12/19/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import UIKit

class SignupVC: UIViewController {

    // MARK: Properties
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
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
    
    private var passwordsMatch: Bool {
        return passwordTextField.text == confirmPasswordTextField.text
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    // MARK: Actions
    
    @IBAction func signupButtonWasTapped(_ sender: OutlineButton) {
        createNewUser()
    }
    
    // MARK: Convenience
    
    private func createNewUser() {
        if let email = email, let password = password {
            guard passwordsMatch else {
                if let navigationController = self.navigationController {
                    let notification = DropDownNotification(text: "The passwords do not match.")
                    notification.presentNotification(onNavigationController: navigationController, forDuration: 3)
                }
                return
            }
            activitySpinner.startAnimating()
            FirebaseDataService.instance.createNewUser(withEmail: email, password: password, completion: { [weak self] (user, error) in
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
