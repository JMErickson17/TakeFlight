//
//  LoginVC.swift
//  TakeFlight
//
//  Created by Justin Erickson on 12/19/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import UIKit
import Firebase

class LoginVC: UIViewController {
    
    // MARK: Properties
    
    @IBOutlet weak var emailTextField: UnderlineTextField!
    @IBOutlet weak var passwordTextField: UnderlineTextField!
    @IBOutlet weak var forgotPasswordLabel: UILabel!
    @IBOutlet weak var activitySpinner: UIActivityIndicatorView!
    
    // TODO: Convert to dependency injection
    lazy var firebaseStorage = FirebaseStorageService(storage: Storage.storage())
    lazy var userService: UserService = FirebaseUserService(database: Firestore.firestore(), userStorage: firebaseStorage)
    
    private var textFieldAttributes: [NSAttributedStringKey: Any] = [
        NSAttributedStringKey.foregroundColor: UIColor.white.withAlphaComponent(0.5)
    ]
    
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

        setupView()
    }
    
    // MARK: Setup
    
    private func setupView() {
        emailTextField.iconImage = #imageLiteral(resourceName: "EmailIcon")
        passwordTextField.iconImage = #imageLiteral(resourceName: "PasswordIcon")
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: textFieldAttributes)
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: textFieldAttributes)
    }
    
    // MARK: Actions

    @IBAction func loginButtonWasTapped(_ sender: OutlineButton) {
        activitySpinner.startAnimating()
        loginUser()
    }
    
    // MARK: Convenience
    
    private func loginUser() {
        if let email = email, let password = password {
            userService.signInUser(withEmail: email, password: password, completion: { [weak self] (user, error) in
                self?.activitySpinner.stopAnimating()
                if let error = error {
                    if let navigationController = self?.navigationController {
                        let notification = DropDownNotification(text: error.localizedDescription)
                        notification.presentNotification(onViewController: navigationController, forDuration: 3)
                    }
                    return
                }
                self?.navigationController?.popToRootViewController(animated: true)
            })
        }
        activitySpinner.stopAnimating()
    }
}
