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

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func signupButtonWasTapped(_ sender: OutlineButton) {
        attemptCreateNewUser()
    }
    
    private func attemptCreateNewUser() {
        if let email = email, let password = password {
            if passwordsMatch {
                FirebaseDataService.instance.createNewUser(withEmail: email, password: password, completion: { [weak self] (user, error) in
                    if let error = error {
                        print(error)
                        return
                    }
                    self?.navigationController?.popToRootViewController(animated: true)
                })
            }
        }
    }
}
