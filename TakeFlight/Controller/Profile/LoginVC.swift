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

        // Do any additional setup after loading the view.
    }
    
    // MARK: Actions

    @IBAction func loginButtonWasTapped(_ sender: OutlineButton) {
        attemptLoginUser()
    }
    
    // MARK: Convenience
    
    private func attemptLoginUser() {
        if let email = email, let password = password {
            FirebaseDataService.instance.signInUser(withEmail: email, password: password, completion: { [weak self] (user, error) in
                if let error = error {
                    print(error)
                    return
                }
                self?.navigationController?.popToRootViewController(animated: true)
            })
        }
    }
}
