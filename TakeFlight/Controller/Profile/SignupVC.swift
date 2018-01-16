//
//  SignupVC.swift
//  TakeFlight
//
//  Created by Justin Erickson on 12/19/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import UIKit
import Firebase

class SignupVC: UIViewController {

    // MARK: Properties
    
    @IBOutlet weak var emailTextField: UnderlineTextField!
    @IBOutlet weak var passwordTextField: UnderlineTextField!
    @IBOutlet weak var confirmPasswordTextField: UnderlineTextField!
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
    
    private var passwordsMatch: Bool {
        return passwordTextField.text == confirmPasswordTextField.text
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    private func setupView() {
        emailTextField.iconImage = #imageLiteral(resourceName: "EmailIcon")
        passwordTextField.iconImage = #imageLiteral(resourceName: "PasswordIcon")
        confirmPasswordTextField.iconImage = #imageLiteral(resourceName: "PasswordIcon")
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: textFieldAttributes)
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: textFieldAttributes)
        confirmPasswordTextField.attributedPlaceholder = NSAttributedString(string: "Confirm Password", attributes: textFieldAttributes)
    }
    // MARK: Actions
    
    @IBAction func signupButtonWasTapped(_ sender: OutlineButton) {
        activitySpinner.startAnimating()
        createNewUser()
    }
    
    // MARK: Convenience
    
    private func createNewUser() {
        if let email = email, let password = password {
            guard passwordsMatch else {
                if let navigationController = self.navigationController {
                    let notification = DropDownNotification(text: "The passwords entered do not match.")
                    notification.presentNotification(onNavigationController: navigationController, forDuration: 3)
                }
                return
            }
            activitySpinner.startAnimating()
            userService.createNewUser(withEmail: email, password: password, completion: { [weak self] (user, error) in
                if let error = error {
                    if let navigationController = self?.navigationController {
                        let notification = DropDownNotification(text: error.localizedDescription)
                        notification.presentNotification(onNavigationController: navigationController, forDuration: 3)
                    }
                    return
                }
                self?.navigationController?.popViewController(animated: true)
            })
        }
        activitySpinner.stopAnimating()
    }
}
