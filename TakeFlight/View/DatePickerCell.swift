//
//  DatePickerCell.swift
//  TakeFlight
//
//  Created by Justin Erickson on 10/15/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import UIKit
import JTAppleCalendar

class DatePickerCell: JTAppleCell {
    
    // MARK: Properties
    
    @IBOutlet weak var dateLabel: UILabel!
    
    // MARK: Convienence
    
    func configureCell(withDate date: String) {
        self.dateLabel.text = date
    }
}
