//
//  LanguagePickerVC.swift
//  TakeFlight
//
//  Created by Justin Erickson on 12/21/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import UIKit

class LanguagePickerVC: UITableViewController {
    
    private var languages = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        languages = ["English", "Spanish", "French", "German"]
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return languages.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "languageCell", for: indexPath)
        let language = languages[indexPath.row]
        cell.textLabel?.text! = language
        return cell
    }


}
