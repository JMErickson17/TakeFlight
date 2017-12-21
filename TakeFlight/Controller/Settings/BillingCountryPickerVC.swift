//
//  BillingCountryPickerVC.swift
//  TakeFlight
//
//  Created by Justin Erickson on 12/21/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import UIKit

class BillingCountryPickerVC: UITableViewController {
    
    private var billingCountries = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        billingCountries = ["United States", "Mexico", "Canada", "Germany"]
    }



    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return billingCountries.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "billingCountryCell", for: indexPath)
        let billingCountry = billingCountries[indexPath.row]
        cell.textLabel?.text! = billingCountry
        return cell
    }
}
