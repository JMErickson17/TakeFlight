//
//  CurrencyPickerVC.swift
//  TakeFlight
//
//  Created by Justin Erickson on 12/21/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import UIKit

class CurrencyPickerVC: UITableViewController {
    
    private var currencies = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        currencies = ["USD", "IDK", "SEX", "KEK"]
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencies.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "currencyCell", for: indexPath)
        let currency = currencies[indexPath.row]
        cell.textLabel?.text! = currency
        return cell
    }


}
