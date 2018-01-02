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
    
    @IBOutlet weak var emailTextField: UnderlineTextField!
    @IBOutlet weak var passwordTextField: UnderlineTextField!
    @IBOutlet weak var confirmPasswordTextField: UnderlineTextField!
    @IBOutlet weak var activitySpinner: UIActivityIndicatorView!
    
    private var textFieldAttributes: [NSAttributedStringKey: Any] = [
        NSAttributedStringKey.foregroundColor: UIColor.white.withAlphaComponent(0.5),
        
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
        emailTextField.leftView = UIImageView(image: #imageLiteral(resourceName: "EmailIcon"))
        passwordTextField.leftView = UIImageView(image: #imageLiteral(resourceName: "PasswordIcon"))
        confirmPasswordTextField.leftView = UIImageView(image: #imageLiteral(resourceName: "PasswordIcon"))
        emailTextField.leftViewMode = UITextFieldViewMode.always
        passwordTextField.leftViewMode = UITextFieldViewMode.always
        confirmPasswordTextField.leftViewMode = UITextFieldViewMode.always
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: textFieldAttributes)
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: textFieldAttributes)
        confirmPasswordTextField.attributedPlaceholder = NSAttributedString(string: "Confirm Password", attributes: textFieldAttributes)
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
                    let notification = DropDownNotification(text: "The passwords entered do not match.")
                    notification.presentNotification(onNavigationController: navigationController, forDuration: 3)
                }
                return
            }
            activitySpinner.startAnimating()
            UserDataService.instance.createNewUser(withEmail: email, password: password, completion: { [weak self] (user, error) in
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
