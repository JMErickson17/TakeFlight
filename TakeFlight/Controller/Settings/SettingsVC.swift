//
//  SettingsVC.swift
//  TakeFlight
//
//  Created by Justin Erickson on 12/21/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import UIKit

class SettingsVC: UITableViewController {
    
    // MARK: Types
    
    private struct Constants {
        static let clearSearchHistoryAlertTitle = "Clear Search History"
        static let clearSearchHistoryAlertMessage = "Are you sure you want to clear all search history?"
        static let toCurrencyPickerVC = "toCurrencyPickerVC"
        static let toLanguagePickerVC = "toLanguagePickerVC"
        static let toBillingCountryPickerVC = "toBillingCountryPickerVC"
    }
    
    private enum SectionType {
        case account
        case regional
        case privacy
    }
    
    private enum Item {
        case firstName
        case lastName
        case email
        case phone
        case changePassword
        case logout
        case currency
        case language
        case billingCountry
        case clearSearchHistory
        case notifications
    }
    
    private struct Section {
        var type: SectionType
        var items: [Item]
    }

    // MARK: Properties
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    private var userDidUpdateListener: NSObjectProtocol?
    
    private lazy var saveButton: UIBarButtonItem = {
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(handleSaveUserDetails))
        return saveButton
    }()
    
    private var updatedValues = [UpdatableUserProperties: String]() {
        didSet {
            if updatedValues.count > 0 {
                addSaveButton()
            } else {
                removeSaveButton()
            }
        }
    }
    
    private lazy var sections: [Section] = {
        let sections = [
            Section(type: .account, items: [.firstName, .lastName, .email, .phone, .changePassword, .logout]),
            Section(type: .regional, items: [.currency, .language, .billingCountry]),
            Section(type: .privacy, items: [.clearSearchHistory, .notifications])
        ]
        return sections
    }()
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        addUserDidUpdateListener()
        configureViewForCurrentUser()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        removeUserDidUpdateListener()
    }
    
    // MARK: Setup
    
    private func setupView() {
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        emailTextField.delegate = self
        phoneNumberTextField.delegate = self
    }
    
    private func addUserDidUpdateListener() {
        userDidUpdateListener = NotificationCenter.default.addObserver(forName: .userPropertiesDidChange, object: nil, queue: nil, using: { _ in
            self.configureViewForCurrentUser()
        })
    }
    
    private func removeUserDidUpdateListener() {
        if let userDidUpdateListener = userDidUpdateListener {
            NotificationCenter.default.removeObserver(userDidUpdateListener)
        }
    }
    
    func configureViewForCurrentUser() {
        if let user = UserDataService.instance.currentUser {
            if let firstName = user.firstName { firstNameTextField.text = firstName }
            if let lastName = user.lastName { lastNameTextField.text = lastName }
            if let phoneNumber = user.phoneNumber { phoneNumberTextField.text = phoneNumber }
            emailTextField.text = user.email
        }
    }
    
    private func addSaveButton() {
        self.navigationItem.setRightBarButton(saveButton, animated: true)
    }
    
    private func removeSaveButton() {
        self.navigationItem.setRightBarButton(nil, animated: true)
    }
    
    @objc private func handleSaveUserDetails() {
        UserDataService.instance.saveToCurrentUser(updatedProperties: updatedValues) { [weak self] error in
            if let error = error {
                if let navigationController = self?.navigationController {
                    let notification = DropDownNotification(text: "Could not save changes.\n\(error)")
                    notification.presentNotification(onNavigationController: navigationController, forDuration: 3)
                }
            }
        }
    }

    // MARK: UITableView Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch sections[indexPath.section].items[indexPath.row] {
        case .firstName: break
        case .lastName: break
        case .email: break
        case .phone: break
        case .changePassword:
            handleChangePassword()
        case .logout:
            handleLogOutCurrentUser()
        case .currency:
            break
//            handleChangeCurrency()
        case .language:
            break
//            handleChangeLanguage()
        case .billingCountry:
            break
//            handleChangeBillingCountry()
        case .clearSearchHistory:
            handleClearHistory()
        case .notifications:
            break
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: Convenience
    
    private func handleChangePassword() {
        // Implement change password functionality
    }
    
    private func handleLogOutCurrentUser() {
        do {
            try UserDataService.instance.signOutCurrentUser()
        } catch{
            print(error)
        }
    }
    
    private func handleChangeCurrency() {
        performSegue(withIdentifier: Constants.toCurrencyPickerVC, sender: nil)
    }
    
    private func handleChangeLanguage() {
        performSegue(withIdentifier: Constants.toLanguagePickerVC, sender: nil)
    }
    
    private func handleChangeBillingCountry() {
        performSegue(withIdentifier: Constants.toBillingCountryPickerVC, sender: nil)
    }
    
    private func handleClearHistory() {
        let alert = UIAlertController(title: Constants.clearSearchHistoryAlertTitle, message: Constants.clearSearchHistoryAlertMessage, preferredStyle: .alert)
        let clearSearchHistoryAction = UIAlertAction(title: "Clear", style: .destructive) { alert in
            UserDataService.instance.clearCurrentUserSearchHistory { error in
                if let error = error { return print(error) }
                
                if let navigationController = self.navigationController {
                    let notification = DropDownNotification(text: "Search history cleared.")
                    notification.presentNotification(onNavigationController: navigationController, forDuration: 3)
                }
            }
        }
        alert.addAction(clearSearchHistoryAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
}

// MARK: SettingsVC+UITextFieldDelegate

extension SettingsVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //addSaveButton()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let currentUser = UserDataService.instance.currentUser else { return }
        
        let newText = textField.text
        switch textField.tag {
        case 0:
            if currentUser.firstName != newText { updatedValues[.firstName] = newText }
        case 1:
            if currentUser.lastName != newText { updatedValues[.lastName] = newText }
        case 2:
            if currentUser.email != newText { updatedValues[.email] = newText }
        case 3:
            if currentUser.phoneNumber != newText { updatedValues[.phoneNumber] = newText }
        default:
            break
        }
        
        if updatedValues.count == 0 {
            removeSaveButton()
        }
    }
}
