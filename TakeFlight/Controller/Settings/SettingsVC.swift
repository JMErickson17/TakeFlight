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
    
    private enum SectionType {
        case account
        case regional
        case privacy
    }
    
    private enum Item {
        case name
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
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    private lazy var sections: [Section] = {
        let sections = [
            Section(type: .account, items: [.name, .email, .phone, .changePassword, .logout]),
            Section(type: .regional, items: [.currency, .language, .billingCountry]),
            Section(type: .privacy, items: [.clearSearchHistory, .notifications])
        ]
        return sections
    }()
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: UITableView Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch sections[indexPath.section].items[indexPath.row] {
        case .name: break
        case .email: break
        case .phone: break
        case .changePassword:
            handleChangePassword()
        case .logout:
            handleLogOutCurrentUser()
        case .currency:
            handleChangeCurrency()
        case .language:
            handleChangeLanguage()
        case .billingCountry:
            handleChangeBillingCountry()
        case .clearSearchHistory:
            break
        case .notifications:
            break
        }
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
        performSegue(withIdentifier: "toCurrencyPickerVC", sender: nil)
    }
    
    private func handleChangeLanguage() {
        performSegue(withIdentifier: "toLanguagePickerVC", sender: nil)
    }
    
    private func handleChangeBillingCountry() {
        performSegue(withIdentifier: "toBillingCountryPickerVC", sender: nil)
    }
}
